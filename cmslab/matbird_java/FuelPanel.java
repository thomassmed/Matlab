/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWArray;
import java.awt.Color;
import java.awt.Font;
import java.text.DecimalFormat;
import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import java.awt.Dimension;
import java.awt.Insets;
import javax.swing.JCheckBox;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
public class FuelPanel extends JPanel {

    DecimalFormat df0 = new DecimalFormat("#");
    public MainPanel mainpanel1;
    private final JLabel u235label;
    private final JLabel balabel;
    public MatLab matlab1;
    Object[] matvec;
    int m;
    int k;
    Object[] matvec1;
    JPanel buttonPanel1;
    JPanel buttonPanel2;
    JCheckBox standard_check;
    JSpinner u235spinner;
    
//    SpinnerNumberModel u235model1;
//    SpinnerNumberModel u235model = new SpinnerNumberModel((int) Math.round((100.0 * matlab1.enr2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 500, 1);


    public FuelPanel(MainPanel mainpanel, MatLab matlab) {
        setBackground(Color.white);
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);

        setPreferredSize(new Dimension(330, 230));

        matlab1 = matlab;
        mainpanel1 = mainpanel;

        u235label = new JLabel("U235");
        u235label.setBounds(20, 20, 50, 25);
        u235label.setFont(new Font("LucidaTypewriterBold", Font.BOLD, 14));
        add(u235label);

        balabel = new JLabel("BA  ");
        balabel.setBounds(20, 70, 50, 25);
        balabel.setFont(new Font("Times New Roman", Font.BOLD, 14));
        add(balabel);

        final SpinnerNumberModel u235model = new SpinnerNumberModel((int) Math.round((100.0 * matlab1.enr2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 500, 1);
        u235spinner = new JSpinner(u235model);
//         u235spinner = new JSpinner(new SpinnerNumberModel((int) Math.round((100.0 * matlab1.enr2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 500, 1));

        u235model.addChangeListener(new ChangeListener() {

            @Override
            public void stateChanged(ChangeEvent e) {
                int spinnervalue;
                int mz;
                double u235_diff;
              double  u235_old;
                Number nr;

                try {

                    if (standard_check.isSelected()) {
                        nr = u235model.getNumber();
                        spinnervalue = nr.intValue();
                        mz = matlab1.standard_u235[0].length-1;
                        m = 0;
                        u235_diff = (double) spinnervalue / 100 - matlab1.enr2[m][mainpanel1.y_enrpos];
                        if (u235_diff > 0.011) {
                            spinnervalue = spinnervalue - 1;
                        } else if (u235_diff < -0.011) {
                            spinnervalue = spinnervalue + 1;
                        }
                        if ((double) spinnervalue / 100 <= matlab1.standard_u235[0][m]) {
                            spinnervalue = (int) matlab1.standard_u235[0][m] * 100;
                        } else if ((double) spinnervalue / 100 >= matlab1.standard_u235[0][mz]) {
                            spinnervalue = (int) matlab1.standard_u235[0][mz] * 100;
                        } else {
                            u235_old = matlab1.enr2[m][mainpanel1.y_enrpos];
                            while (m < mz && matlab1.standard_u235[0][m] < (double) spinnervalue / 100) {
                                m = m + 1;
                            }
                            if ((double) spinnervalue / 100 > u235_old) {
                                spinnervalue = Math.round((float) matlab1.standard_u235[0][m] * 100);
                            } else {
                                spinnervalue = Math.round((float) matlab1.standard_u235[0][m - 1] * 100);
                            }
                        }
                    } else {
                        nr = u235model.getNumber();
                        spinnervalue = nr.intValue();
                    }

//                    newU235 = spinnervalue;
                    u235spinner.setValue(spinnervalue);
//                    u235spinner.setModel(new SpinnerNumberModel((int) Math.round((100.0 * matlab1.enr2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 500, 1));


                    for (m = 0; m <= mainpanel1.cnmax; m++) {
                        if (mainpanel1.ax_check[m].isSelected()) {
                            matlab1.enr2[m][mainpanel1.y_enrpos] = (double) spinnervalue / 100;
                            matlab1.matte.java_u235_spinner_callback(m + 1, mainpanel1.y_enrpos + 1, (double) spinnervalue / 100);
                            matvec1 = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                            MWNumericArray mu235 = (MWNumericArray) matvec1[10];
                            matlab1.u235[m] = mu235.getDouble();
                            MWArray.disposeArray(mu235);
                            if (!mainpanel1.axial_btf_check.isSelected()) {
                                mainpanel1.u235_str = "U235 = " + mainpanel1.df3.format(matlab1.u235[mainpanel1.cn]);
                                mainpanel1.u235_message.setText(mainpanel1.u235_str);
                            }
                        }
                    }

//                    u235spinner.setModel(new SpinnerNumberModel((int) Math.round((100.0 * matlab1.enr2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 500, 1));

                    matvec1 = matlab1.matte.java_calc_mean_u235(1);
                    MWNumericArray mmean_u235 = (MWNumericArray) matvec1[0];
                    matlab1.mean_u235 = mmean_u235.getDouble();
                    MWArray.disposeArray(mmean_u235);
                    if (mainpanel1.axial_btf_check.isSelected()) {
                        mainpanel1.u235_str = "<U235> = " + mainpanel1.df3.format(matlab1.mean_u235);
                        mainpanel1.u235_message.setText(mainpanel1.u235_str);
                    }
                    mainpanel1.repaint();

                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });
        u235spinner.setBounds(90, 20, 70, 25);
        Font font_spinner = new Font("Times New Roman", Font.BOLD, 14);
        u235spinner.setFont(font_spinner);
        add(u235spinner);


        final SpinnerNumberModel bamodel = new SpinnerNumberModel((int) Math.round((100.0 * matlab.ba2[mainpanel1.cn][mainpanel1.y_enrpos])), 0, 2000, 1);
        JSpinner baspinner = new JSpinner(bamodel);
        bamodel.addChangeListener(new ChangeListener() {

            @Override
            public void stateChanged(ChangeEvent e) {

                try {
                    Number nr = bamodel.getNumber();
                    int spinnervalue = nr.intValue();
                    for (k = 0; k <= mainpanel1.cnmax; k++) {
                        if (mainpanel1.ax_check[k].isSelected()) {
                            matlab1.ba2[k][mainpanel1.y_enrpos] = (double) spinnervalue / 100;
                            matlab1.matte.java_ba_spinner_callback(k + 1, mainpanel1.y_enrpos + 1, (double) spinnervalue / 100);
                            mainpanel1.repaint();
                        }
                    }
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });
        baspinner.setBounds(90, 70, 70, 25);
        baspinner.setFont(font_spinner);
        add(baspinner);

//        Insets ins = new Insets(2, 2, 2, 2);
        Dimension dim = new Dimension(85, 30);


        buttonPanel1 = new JPanel();
        buttonPanel1.setBackground(Color.white);
//        buttonPanel1.setBackground(Color.pink);
        buttonPanel1.setBounds(190, 15, 120, 120);
        add(buttonPanel1);

        javax.swing.JButton addrod = new javax.swing.JButton("Add rod");
        addrod.setFont(mainpanel1.font_button);
//        addrod.setMargin(ins);
        addrod.setPreferredSize(dim);
        buttonPanel1.add(addrod);
        addrod.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                for (m = 0; m <= mainpanel1.cnmax; m++) {
                    if (mainpanel1.ax_check[m].isSelected()) {
                        try {
                            matlab1.matte.java_addrod(m + 1, mainpanel1.y_enrpos + 1);
                            matlab1.matte.java_sortrods(m + 1);
                            matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                            MWNumericArray mlfu = (MWNumericArray) matvec[1];
                            matlab1.lfu[m] = (int[][]) mlfu.toIntArray();
                            MWArray.disposeArray(mlfu);
                            MWNumericArray menr2 = (MWNumericArray) matvec[6];
                            matlab1.enr2[m] = menr2.getDoubleData();
                            MWArray.disposeArray(menr2);
                            MWNumericArray mba2 = (MWNumericArray) matvec[7];
                            matlab1.ba2[m] = mba2.getDoubleData();
                            MWArray.disposeArray(mba2);
                            MWNumericArray mba = (MWNumericArray) matvec[19];
                            matlab1.ba[m] = (double[][]) mba.toDoubleArray();
                            MWArray.disposeArray(mba);
                            MWNumericArray menr = (MWNumericArray) matvec[20];
                            matlab1.enr[m] = (double[][]) menr.toDoubleArray();
                            MWArray.disposeArray(menr);
                            MWNumericArray menr1 = (MWNumericArray) matvec[35];
                            matlab1.enr1[m] = menr1.getIntData();
                            MWArray.disposeArray(menr1);

                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
                mainpanel1.repaint();
            }
        });

        javax.swing.JButton delrod = new javax.swing.JButton("Del rod");
        delrod.setFont(mainpanel1.font_button);
//        delrod.setMargin(ins);
        delrod.setPreferredSize(dim);
        buttonPanel1.add(delrod);
        delrod.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                for (m = 0; m <= mainpanel1.cnmax; m++) {
                    if (mainpanel1.ax_check[m].isSelected()) {
                        try {
                            matlab1.matte.java_delrod(m + 1, mainpanel1.y_enrpos + 1);
                            matlab1.matte.java_sortrods(m + 1);
                            matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                            MWNumericArray mlfu = (MWNumericArray) matvec[1];
                            matlab1.lfu[m] = (int[][]) mlfu.toIntArray();
                            MWArray.disposeArray(mlfu);
                            MWNumericArray menr2 = (MWNumericArray) matvec[6];
                            matlab1.enr2[m] = menr2.getDoubleData();
                            MWArray.disposeArray(menr2);
                            MWNumericArray mba2 = (MWNumericArray) matvec[7];
                            matlab1.ba2[m] = mba2.getDoubleData();
                            MWArray.disposeArray(mba2);
                            MWNumericArray mba = (MWNumericArray) matvec[19];
                            matlab1.ba[m] = (double[][]) mba.toDoubleArray();
                            MWArray.disposeArray(mba);
                            MWNumericArray menr = (MWNumericArray) matvec[20];
                            matlab1.enr[m] = (double[][]) menr.toDoubleArray();
                            MWArray.disposeArray(menr);
                            MWNumericArray menr1 = (MWNumericArray) matvec[35];
                            matlab1.enr1[m] = menr1.getIntData();
                            MWArray.disposeArray(menr1);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
                mainpanel1.repaint();
            }
        });

        javax.swing.JButton sortrods = new javax.swing.JButton("Sort rods");
        sortrods.setFont(mainpanel1.font_button);
//        sortrods.setMargin(ins);
        sortrods.setPreferredSize(dim);
        buttonPanel1.add(sortrods);
        sortrods.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                for (m = 0; m <= mainpanel1.cnmax; m++) {
                    if (mainpanel1.ax_check[m].isSelected()) {
                        try {
                            matlab1.matte.java_sortrods(m + 1);
                            matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                            MWNumericArray mlfu = (MWNumericArray) matvec[1];
                            matlab1.lfu[m] = (int[][]) mlfu.toIntArray();
                            MWArray.disposeArray(mlfu);
                            MWNumericArray menr2 = (MWNumericArray) matvec[6];
                            matlab1.enr2[m] = menr2.getDoubleData();
                            MWArray.disposeArray(menr2);
                            MWNumericArray mba2 = (MWNumericArray) matvec[7];
                            matlab1.ba2[m] = mba2.getDoubleData();
                            MWArray.disposeArray(mba2);
                            MWNumericArray menr1 = (MWNumericArray) matvec[35];
                            matlab1.enr1[m] = menr1.getIntData();
                            MWArray.disposeArray(menr1);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
                mainpanel1.repaint();
            }
        });

        buttonPanel2 = new JPanel();
        buttonPanel2.setBackground(Color.white);
//        buttonPanel2.setBackground(Color.pink);
        buttonPanel2.setBounds(20, 150, 290, 40);
        add(buttonPanel2);

        standard_check = new JCheckBox("Standard fuel vendor enrichments", true);
        standard_check.setFont(mainpanel1.font_button);
        buttonPanel2.add(standard_check);



    }
}
