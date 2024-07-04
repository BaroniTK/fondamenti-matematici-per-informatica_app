package com.example.fondamentiapp;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import org.jgrapht.Graph;
import org.jgrapht.graph.DefaultEdge;

import java.util.HashMap;
import java.util.Map;

public class GraphView extends View {

    private Graph<Integer, DefaultEdge> graph;
    private Paint nodePaint;
    private Paint edgePaint;
    private Map<Integer, Point> nodePositions;
    private Integer movingNode = null;

    public GraphView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        nodePaint = new Paint();
        nodePaint.setColor(Color.BLUE);
        nodePaint.setStyle(Paint.Style.FILL);
        nodePaint.setAntiAlias(true);

        edgePaint = new Paint();
        edgePaint.setColor(Color.BLACK);
        edgePaint.setStrokeWidth(5);
        edgePaint.setAntiAlias(true);

        nodePositions = new HashMap<>();
    }

    public void setGraph(Graph<Integer, DefaultEdge> graph) {
        this.graph = graph;
        post(new Runnable() {
            @Override
            public void run() {
                generateNodePositions();
                invalidate();
            }
        });
    }

    private void generateNodePositions() {
        int width = getWidth();
        int height = getHeight();
        int radius = Math.min(width, height) / 2 - 100;
        int centerX = width / 2;
        int centerY = height / 2;
        int numVertices = graph.vertexSet().size();

        double angleStep = 2 * Math.PI / numVertices;

        int index = 0;
        for (Integer vertex : graph.vertexSet()) {
            int x = centerX + (int) (radius * Math.cos(index * angleStep));
            int y = centerY + (int) (radius * Math.sin(index * angleStep));
            nodePositions.put(vertex, new Point(x, y));
            index++;
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (graph != null && !nodePositions.isEmpty()) {
            drawGraph(canvas);
        }
    }



    private void drawGraph(Canvas canvas) {
        for (DefaultEdge edge : graph.edgeSet()) {
            int u = graph.getEdgeSource(edge);
            int v = graph.getEdgeTarget(edge);
            Point p1 = nodePositions.get(u);
            Point p2 = nodePositions.get(v);
            if (p1 != null && p2 != null) {
                canvas.drawLine(p1.x, p1.y, p2.x, p2.y, edgePaint);
            }
        }

        for (Map.Entry<Integer, Point> entry : nodePositions.entrySet()) {
            Point point = entry.getValue();
            canvas.drawCircle(point.x, point.y, 30, nodePaint);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                movingNode = getNodeAt(event.getX(), event.getY());
                if (movingNode != null) {
                    // Disallow parent view to intercept touch events.
                    getParent().requestDisallowInterceptTouchEvent(true);
                }
                return movingNode != null;

            case MotionEvent.ACTION_MOVE:
                if (movingNode != null) {
                    nodePositions.get(movingNode).x = (int) event.getX();
                    nodePositions.get(movingNode).y = (int) event.getY();
                    invalidate();
                    return true;
                }
                break;

            case MotionEvent.ACTION_UP:
                if (movingNode != null) {
                    movingNode = null;
                    // Allow parent view to intercept touch events.
                    getParent().requestDisallowInterceptTouchEvent(false);
                }
                break;
        }
        return super.onTouchEvent(event);
    }

    private Integer getNodeAt(float x, float y) {
        for (Map.Entry<Integer, Point> entry : nodePositions.entrySet()) {
            Point point = entry.getValue();
            if (Math.pow(x - point.x, 2) + Math.pow(y - point.y, 2) <= Math.pow(30, 2)) {
                return entry.getKey();
            }
        }
        return null;
    }

    class Point {
        int x, y;

        Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }
}
