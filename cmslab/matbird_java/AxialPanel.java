/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWException;
//import com.mathworks.toolbox.javabuilder.MWNumericArray;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.text.DecimalFormat;
import javax.swing.BorderFactory;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
class AxialPanel extends JPanel {

    public MainPanel mainpanel1;
    public MatLab matlab1;
    public JCheckBox[] ax_check;
    public JSpinner[] ax_spinner;
    public JSpinner crd_spinner;
    public SpinnerNumberModel[] ax_spinnermodel;
    public SpinnerNumberModel  crd_spinnermodel;
    private JLabel totallabel;
    Graphics g;
    int total = 600;
    Object[] matvec;
    Font font_labels = new Font("LucidaTypewriterBold", Font.BOLD, 12);
    int i;
    int j;
    int m;
    DecimalFormat df3 = new DecimalFormat("0.000");

    public AxialPanel(MainPanel mainpanel, MatLab matlab) {

        matlab1 = matlab;
        mainpanel1 = mainpanel;
        setBackground(Color.white);
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);
        setPreferredSize(new Dimension(500, 700));

        ax_check = new JCheckBox[mainpanel1.cnmax + 1];
        ax_spinner = new JSpinner[mainpanel1.cnmax + 1];
        ax_spinnermodel = new SpinnerNumberModel[10];

//        crd_spinner = new JSpinner[1];
//        crd_spinnermodel = new SpinnerNumberModel[100];



        for (i = 0; i <= mainpanel1.cnmax; i++) {
            ax_spinnermodel[i] = null;
        }

        Font font_spinner = new Font("Times New Roman", Font.BOLD, 14);

        int sum1 = total;
        for (i = 0; i <= mainpanel1.cnmax; i++) {
            ax_spinnermodel[i] = new SpinnerNumberModel((int) Math.round((100.0 * matlab1.axial_zone[i][i])), 0, 100, 1);
            ax_spinner[i] = new JSpinner(ax_spinnermodel[i]);
            ax_spinner[i].setFont(font_spinner);
            ax_spinner[i].setBounds(200, sum1, 70, 25);
            add(ax_spinner[i]);
            mainpanel1.ax_check[i].setBounds(20, sum1, 130, 20);
            mainpanel1.ax_check[i].setFont(font_labels);
            add(mainpanel1.ax_check[i]);
            sum1 = sum1 - (int) (total * matlab1.axial_zone[i][i]);
        }

        for (j = 0; j <= mainpanel1.cnmax; j++) {
                ax_spinnermodel[j].addChangeListener(new ChangeListener() {
                    @Override
                    public void stateChanged(ChangeEvent e) {
                        try {
                            for (m = 0; m <= mainpanel1.cnmax; m++) {
                                for (i = 0; i <= mainpanel1.cnmax; i++) {
                                    Number nr = ax_spinnermodel[i].getNumber();
                                    int spinnervalue = nr.intValue();
                                    matlab1.axial_zone[m][i] = (double) spinnervalue / 100;
                                    matlab1.matte.java_axial_spinner_callback(m + 1, i + 1, (double) spinnervalue / 100);
                                }
                            }
                            matlab1.matvec1 = matlab1.matte.java_calc_mean_u235(1);
                            matlab1.mmean_u235 = (MWNumericArray) matlab1.matvec1[0];
                            matlab1.mean_u235 = matlab1.mmean_u235.getDouble();
                            MWArray.disposeArray(matlab1.mean_u235);
                        } catch (MWException ex) {
                        Exceptions.printStackTrace(ex);
                    }
                    repaint();
                }
            });
        }

        crd_spinnermodel = new SpinnerNumberModel(100, 0, 100, 1);
        crd_spinner = new JSpinner(crd_spinnermodel);
        crd_spinner.setFont(font_spinner);
        crd_spinner.setBounds(400, 650, 70, 25);
        add(crd_spinner);


        crd_spinnermodel.addChangeListener(new ChangeListener() {

            @Override
            public void stateChanged(ChangeEvent e) {
                try {
                    Number nr = crd_spinnermodel.getNumber();
                    int spinnervalue = nr.intValue();
                    matlab1.matte.java_crd_spinner_callback((double)spinnervalue);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
//                mainpanel1.update();
                repaint();
            }
        });


        totallabel = new JLabel("Total   100 %");
        totallabel.setBounds(220, total + 50, 150, 25);
        totallabel.setFont(font_labels);
//        totallabel.setText("Hum");
        add(totallabel);



    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        int sum1 = total;
        int sum = total;
        int sum2 = 0;
        String [] ss;
        String str;
        for (int k = 0; k <= mainpanel1.cnmax; k++) {
            sum = sum - (int) (total * matlab1.axial_zone[k][k]);
            g.setColor(mainpanel1.grafdata.color[k]);
            g.fillRect(150, 20 + sum, 50, (int) (total * matlab1.axial_zone[k][k]));
            ax_spinner[k].setBounds(220, sum1, 50, 20);
            add(ax_spinner[k]);
            mainpanel1.ax_check[k].setBounds(20, sum1, 130, 20);
            add(mainpanel1.ax_check[k]);
            g.setColor(Color.black);
//            g.setColor(Color.white);
            g.setFont(font_labels);
            str = df3.format(matlab1.u235[k]);
            g.drawString(str, 150 + 5, sum1 + 12);
//            ss = matlab1.sim[k].split("SIM");
//            g.drawString(ss[1], 270 + 5, sum1 + 12);
            g.drawString(matlab1.sim[k], 270 + 5, sum1 + 12);

            sum1 = sum1 - (int) (total * matlab1.axial_zone[k][k]);
            sum2 = sum2 + Math.round((float) matlab1.axial_zone[k][k] * 100);
        }
        str = ("Total = " + sum2 + " %");
        totallabel.setText(str);

        Number nr = crd_spinnermodel.getNumber();
        int spinnervalue = nr.intValue();

        g.setColor(mainpanel1.grafdata.color[11]);
        g.fillRect(400, 20 + (spinnervalue) * total / 100 - 1, 30, (100 - spinnervalue) * total / 100 + 1);
        g.setColor(Color.black);
        g.drawString("CRD", 450,  25+(spinnervalue) * total / 100 - 1);


    }
}
