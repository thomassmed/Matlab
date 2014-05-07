/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWException;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import javax.swing.JPanel;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.Range;
import org.jfree.data.xy.XYDataset;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.openide.util.Exceptions;

public class PlotPanel extends JPanel {

    public MainPanel mainpanel1;
    public MatLab matlab1;
    XYDataset dataset;
    JFreeChart chart;
    XYPlot plot;
    ChartPanel chartPanel;
    JPanel panel1;
//    JPanel panel2;
    XYSeries[] series;

    public PlotPanel(MainPanel mainpanel, MatLab matlab) {

        matlab1 = matlab;
        mainpanel1 = mainpanel;
        setLayout(null);
        setPreferredSize(new Dimension(600, 500));

        panel1 = new JPanel();
        panel1.setBackground(Color.white);
//        panel1.setBackground(Color.green);
        panel1.setBounds(10, 10, 360, 50);
        add(panel1);

        javax.swing.JButton kinf = new javax.swing.JButton("kinf");
        kinf.setFont(mainpanel1.font_button);
        panel1.add(kinf);
        kinf.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataset = kinfDataset();
                chart = ChartFactory.createXYLineChart(
                        " ", // chart title
                        "burnup", // x axis label
                        "kinf", // y axis label
                        dataset, // data
                        PlotOrientation.VERTICAL,
                        true, // include legend
                        true, // tooltips
                        false // urls
                        );
                plot = chart.getXYPlot();
                NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
                rangeAxis.setAutoRange(true);
                rangeAxis.setRange(new Range(matlab1.plotminkinf, matlab1.plotmaxkinf));
                plot.getDomainAxis().setLowerMargin(0.0);
                plot.getDomainAxis().setUpperMargin(0.0);
                plot.setBackgroundPaint(Color.white);
//                plot.setRangeGridlineStroke(new BasicStroke(1.0F));
                plot.setRangeGridlinePaint(Color.black);
                plot.setDomainGridlinePaint(Color.black);

//                plot.setBackgroundPaint(Color.lightGray);


                chartPanel.setChart(chart);
                add(chartPanel);
                repaint();
            }
        });

        javax.swing.JButton fint = new javax.swing.JButton("fint");
        fint.setFont(mainpanel1.font_button);
        panel1.add(fint);
        fint.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataset = fintDataset();
                chart = ChartFactory.createXYLineChart(
                        " ", // chart title
                        "burnup", // x axis label
                        "fint", // y axis label
                        dataset, // data
                        PlotOrientation.VERTICAL,
                        true, // include legend
                        true, // tooltips
                        false // urls
                        );
                plot = chart.getXYPlot();
                NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
                rangeAxis.setAutoRange(true);
                rangeAxis.setRange(new Range(1.0, matlab1.plotmaxfint));
                plot.getDomainAxis().setLowerMargin(0.0);
                plot.getDomainAxis().setUpperMargin(0.0);
                plot.setBackgroundPaint(Color.white);
                plot.setRangeGridlinePaint(Color.black);
                plot.setDomainGridlinePaint(Color.black);
                chartPanel.setChart(chart);
                add(chartPanel);
                repaint();
            }
        });


        javax.swing.JButton maxbtfax = new javax.swing.JButton("BTF");
        maxbtfax.setFont(mainpanel1.font_button);
        panel1.add(maxbtfax);
        maxbtfax.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataset = maxbtfaxDataset();
                chart = ChartFactory.createXYLineChart(
                        " ", // chart title
                        "burnup", // x axis label
                        "BTF", // y axis label
                        dataset, // data
                        PlotOrientation.VERTICAL,
                        true, // include legend
                        true, // tooltips
                        false // urls
                        );
                plot = chart.getXYPlot();
                NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
                rangeAxis.setAutoRange(true);
                rangeAxis.setRange(new Range(matlab1.plotminbtf, matlab1.plotmaxbtf));
                plot.getDomainAxis().setLowerMargin(0.0);
                plot.getDomainAxis().setUpperMargin(0.0);
                plot.setBackgroundPaint(Color.white);
                plot.setRangeGridlinePaint(Color.black);
                plot.setDomainGridlinePaint(Color.black);
                chartPanel.setChart(chart);
                add(chartPanel);
                repaint();
            }
        });


        javax.swing.JButton btffile = new javax.swing.JButton("BTF-file");
        btffile.setFont(mainpanel1.font_button);
        panel1.add(btffile);
        btffile.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {
                    matlab1.matte.java_writebtffile();
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });


         javax.swing.JButton oldmaxbtfax = new javax.swing.JButton("old BTF");
        oldmaxbtfax.setFont(mainpanel1.font_button);
        panel1.add(oldmaxbtfax);
        oldmaxbtfax.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataset = oldmaxbtfaxDataset();
                chart = ChartFactory.createXYLineChart(
                        " ", // chart title
                        "burnup", // x axis label
                        "old BTF", // y axis label
                        dataset, // data
                        PlotOrientation.VERTICAL,
                        true, // include legend
                        true, // tooltips
                        false // urls
                        );
                plot = chart.getXYPlot();
                NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
                rangeAxis.setAutoRange(true);
                rangeAxis.setRange(new Range(matlab1.plotoldminbtf, matlab1.plotoldmaxbtf));
                plot.getDomainAxis().setLowerMargin(0.0);
                plot.getDomainAxis().setUpperMargin(0.0);
                plot.setBackgroundPaint(Color.white);
                plot.setRangeGridlinePaint(Color.black);
                plot.setDomainGridlinePaint(Color.black);
                chartPanel.setChart(chart);
                add(chartPanel);
                repaint();
            }
        });

        javax.swing.JButton oldfint = new javax.swing.JButton("old fint");
        oldfint.setFont(mainpanel1.font_button);
        panel1.add(oldfint);
        oldfint.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                dataset = oldfintDataset();
                chart = ChartFactory.createXYLineChart(
                        " ", // chart title
                        "burnup", // x axis label
                        "old fint", // y axis label
                        dataset, // data
                        PlotOrientation.VERTICAL,
                        true, // include legend
                        true, // tooltips
                        false // urls
                        );
                plot = chart.getXYPlot();
                NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
                rangeAxis.setAutoRange(true);
                rangeAxis.setRange(new Range(1.0, matlab1.plotoldmaxfint));
                plot.getDomainAxis().setLowerMargin(0.0);
                plot.getDomainAxis().setUpperMargin(0.0);
                plot.setBackgroundPaint(Color.white);
                plot.setRangeGridlinePaint(Color.black);
                plot.setDomainGridlinePaint(Color.black);
                chartPanel.setChart(chart);
                add(chartPanel);
                repaint();
            }
        });


        dataset = kinfDataset();
        chart = ChartFactory.createXYLineChart(
                " ", // chart title
                "burnup", // x axis label
                "kinf", // y axis label
                dataset, // data
                PlotOrientation.VERTICAL,
                true, // include legend
                true, // tooltips
                false // urls
                );
        plot = chart.getXYPlot();
        NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
        rangeAxis.setAutoRange(true);
        rangeAxis.setRange(new Range(0.7, 1.3));
        plot.getDomainAxis().setLowerMargin(0.0);
        plot.getDomainAxis().setUpperMargin(0.0);
        plot.setBackgroundPaint(Color.white);
        plot.setRangeGridlinePaint(Color.black);
        plot.setDomainGridlinePaint(Color.black);
        chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(580, 400));
        chartPanel.setBounds(10, 100, 580, 400);
        add(chartPanel);
    }

    private XYDataset kinfDataset() {

        series = new XYSeries[mainpanel1.cnmax + 1];
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
            series[m] = new XYSeries(matlab1.sim[m]);
            for (int k = 0; k < matlab1.Nburnup[mainpanel1.cn]; k++) {
                series[m].add(matlab1.burnup[m][k], matlab1.kinf[m][k]);
            }
        }
        XYSeriesCollection datasets = new XYSeriesCollection();
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
            datasets.addSeries(series[m]);
        }
        return datasets;
    }

    private XYDataset fintDataset() {

        series = new XYSeries[mainpanel1.cnmax + 1];
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
//            series[m] = new XYSeries(matlab1.files[m]);
            series[m] = new XYSeries(matlab1.sim[m]);
            for (int k = 0; k < matlab1.Nburnup[mainpanel1.cn]; k++) {
                series[m].add(matlab1.burnup[m][k], matlab1.fint[m][k]);
            }
        }
        XYSeriesCollection datasets = new XYSeriesCollection();
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
            datasets.addSeries(series[m]);
        }
        return datasets;
    }

    private XYDataset maxbtfaxDataset() {

        series = new XYSeries[mainpanel1.cn + 1];
//        for (int m = 0; m < mainpanel1.cnmax+1; m++) {
        series[mainpanel1.cn] = new XYSeries(matlab1.sim[mainpanel1.cn]);
        for (int k = 0; k < matlab1.Nburnup[mainpanel1.cn]; k++) {
            series[mainpanel1.cn].add(matlab1.burnup[mainpanel1.cn][k], matlab1.maxbtfax[mainpanel1.cn][k]);
        }
//        }
        XYSeriesCollection datasets = new XYSeriesCollection();
//        for (int m = 0; m < mainpanel1.cnmax+1; m++) {
        datasets.addSeries(series[mainpanel1.cn]);
//        }
        return datasets;
    }

    private XYDataset oldmaxbtfaxDataset() {

        series = new XYSeries[mainpanel1.cn + 1];
//        for (int m = 0; m < mainpanel1.cnmax+1; m++) {
        series[mainpanel1.cn] = new XYSeries(matlab1.sim[mainpanel1.cn]);
        for (int k = 0; k < matlab1.Nburnup[mainpanel1.cn]; k++) {
            series[mainpanel1.cn].add(matlab1.burnup[mainpanel1.cn][k], matlab1.oldmaxbtfax[mainpanel1.cn][k]);
        }
//        }
        XYSeriesCollection datasets = new XYSeriesCollection();
//        for (int m = 0; m < mainpanel1.cnmax+1; m++) {
        datasets.addSeries(series[mainpanel1.cn]);
//        }
        return datasets;
    }



    private XYDataset oldfintDataset() {

        series = new XYSeries[mainpanel1.cnmax + 1];
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
//            series[m] = new XYSeries(matlab1.files[m]);
            series[m] = new XYSeries(matlab1.sim[m]);
            for (int k = 0; k < matlab1.Nburnup[mainpanel1.cn]; k++) {
                series[m].add(matlab1.burnup[m][k], matlab1.oldfint[m][k]);
            }
        }
        XYSeriesCollection datasets = new XYSeriesCollection();
        for (int m = 0; m < mainpanel1.cnmax + 1; m++) {
            datasets.addSeries(series[m]);
        }
        return datasets;
    }



}
