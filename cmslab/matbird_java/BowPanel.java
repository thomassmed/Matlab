/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import com.mathworks.toolbox.javabuilder.MWArray;
import java.awt.Color;
import java.awt.Dimension;
import javax.swing.BorderFactory;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
public class BowPanel extends JPanel {

    public MainPanel mainpanel1;
    public MatLab matlab1;
    Object[] matvec1 = null;
    double bow;
    int fff, top_nr1;
    JComboBox bowlist1;
    JComboBox bowlist2;
    private JLabel bowlabel1;
    private JLabel bowlabel2;
    private JTextArea textArea;
    int[] bur_index = new int[6];
    double[] btf_0 = new double[6];
    double[] btf_1 = new double[6];
    double[] btf_2 = new double[6];
    String[] bowStrings = {"0.00", "0.25", "0.50", "0.75", "1.00", "1.25", "1.50", "1.75", "2.00", "2.25", "2.50", "2.75", "3.00",
        "-0.25", "-0.50", "-0.75", "-1.00", "-1.25", "-1.50", "-1.75", "-2.00", "-2.25", "-2.50", "-2.75", "-3.00"};

    public BowPanel(MainPanel mainpanel, MatLab matlab) {

        matlab1 = matlab;
        mainpanel1 = mainpanel;

        setBackground(Color.white);
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);
        setPreferredSize(new Dimension(570, 330));

        JPanel panel1 = new JPanel();
        panel1.setBackground(Color.white);
//        panel1.setBackground(Color.green);
        panel1.setBounds(10, 20, 400, 40);
        add(panel1);

        bowlabel1 = new JLabel("Channel bow mm", JLabel.LEFT);
        bowlabel1.setFont(mainpanel1.font_button);
        panel1.add(bowlabel1);

        bowlist1 = new JComboBox(bowStrings);
        bowlist1.setSelectedIndex(0);
        panel1.add(bowlist1);

        bowlist1.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                fff = bowlist1.getSelectedIndex();
                bow = Double.valueOf(bowStrings[fff]);
                calc_channel_bow_peanalty(bow);
            }
        });

        bowlabel2 = new JLabel("        ", JLabel.LEFT);
        panel1.add(bowlabel2);

        javax.swing.JButton channel_penalty = new javax.swing.JButton("Channel penalty");
        channel_penalty.setFont(mainpanel1.font_button);
        panel1.add(channel_penalty);

        channel_penalty.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                calc_channel_bow_peanalty_vector();

                String bur0 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[0]]);
                String bur1 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[1]]);
                String bur2 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[2]]);
                String bur3 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[3]]);
                String bur4 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[4]]);
                String bur5 = mainpanel1.df2.format(matlab1.burnup[0][bur_index[5]]);

                String btf1_0 = mainpanel1.df3.format((btf_1[0] / btf_0[0] - 1) * 100);
                String btf1_1 = mainpanel1.df3.format((btf_1[1] / btf_0[1] - 1) * 100);
                String btf1_2 = mainpanel1.df3.format((btf_1[2] / btf_0[2] - 1) * 100);
                String btf1_3 = mainpanel1.df3.format((btf_1[3] / btf_0[3] - 1) * 100);
                String btf1_4 = mainpanel1.df3.format((btf_1[4] / btf_0[4] - 1) * 100);
                String btf1_5 = mainpanel1.df3.format((btf_1[5] / btf_0[5] - 1) * 100);

                String btf2_0 = mainpanel1.df3.format((btf_2[0] / btf_0[0] - 1) * 100);
                String btf2_1 = mainpanel1.df3.format((btf_2[1] / btf_0[1] - 1) * 100);
                String btf2_2 = mainpanel1.df3.format((btf_2[2] / btf_0[2] - 1) * 100);
                String btf2_3 = mainpanel1.df3.format((btf_2[3] / btf_0[3] - 1) * 100);
                String btf2_4 = mainpanel1.df3.format((btf_2[4] / btf_0[4] - 1) * 100);
                String btf2_5 = mainpanel1.df3.format((btf_2[5] / btf_0[5] - 1) * 100);

                String space1 = "          ";
                String space2 = "                                      ";
                String space3 = "                                  ";
                String cr = "\n";

                String sss = "CPR penalty in %/mm bowing calculated using 1 mm bowing\n\n"
                        + "Burnup MWd/kgU         Bowing away from CRD       Bowing towards CRD\n"
                        + "  " + space1 + bur0 + space2 + btf1_0 + space3 + btf2_0 + cr
                        + "  " + space1 + bur1 + space2 + btf1_1 + space3 + btf2_1 + cr
                        + "  " + space1 + bur2 + space2 + btf1_2 + space3 + btf2_2 + cr
                        + "  " + space1 + bur3 + space2 + btf1_3 + space3 + btf2_3 + cr
                        + space1 + bur4 + space2 + btf1_4 + space3 + btf2_4 + cr
                        + space1 + bur5 + space2 + btf1_5 + space3 + btf2_5 + cr;

                textArea.setText(sss);
            }
        });


        JPanel panel2 = new JPanel();
        panel2.setBackground(Color.white);
//        panel2.setBackground(Color.yellow);
        panel2.setBounds(10, 100, 550, 210);
        add(panel2);

        textArea = new JTextArea("CPR penalty in %/mm bowing calculated using 1 mm bowing", 10, 40);
        panel2.add(textArea);

    }

    public void calc_channel_bow_peanalty(double bow) {

        for (int i = 0; i <= mainpanel1.cnmax; i++) {
            try {
                matlab1.matte.java_calcbow(i + 1, 0.0);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, i + 1);
                matlab1.mpow = (MWNumericArray) matlab1.matvec[2];
                matlab1.pow[i] = (double[][][]) matlab1.mpow.toDoubleArray();
                matlab1.mfint = (MWNumericArray) matlab1.matvec[13];
                matlab1.fint[i] = matlab1.mfint.getDoubleData();
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            if (mainpanel1.axial_btf_check.isSelected()) {
                try {
                    matlab1.matte.java_calcbtf(i + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        }
        mainpanel1.update();

        for (int i = 0; i <= mainpanel1.cnmax; i++) {
            try {
                matlab1.matte.java_calcbow(i + 1, bow);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, i + 1);
                matlab1.mpow = (MWNumericArray) matlab1.matvec[2];
                matlab1.pow[i] = (double[][][]) matlab1.mpow.toDoubleArray();
                matlab1.mfint = (MWNumericArray) matlab1.matvec[13];
                matlab1.fint[i] = matlab1.mfint.getDoubleData();
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            if (mainpanel1.axial_btf_check.isSelected()) {
                try {
                    matlab1.matte.java_calcbtf(i + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        }

        if (mainpanel1.axial_btf_check.isSelected()) {
            try {
                matlab1.matvec = matlab1.matte.java_calcbtfax(1);
                matlab1.matvec = matlab1.matte.java_calcbtfaxenv(3);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            for (int i = 0; i <= mainpanel1.cnmax; i++) {
                try {
                    matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, i + 1);
                    matlab1.mbtfax = (MWNumericArray) matlab1.matvec[11];
                    matlab1.btfax[i] = (double[][][]) matlab1.mbtfax.toDoubleArray();
                    MWArray.disposeArray(matlab1.mbtfax);
                    matlab1.mbtfax_env = (MWNumericArray) matlab1.matvec[12];
                    matlab1.btfax_env[i] = (double[][]) matlab1.mbtfax_env.toDoubleArray();
                    MWArray.disposeArray(matlab1.mbtfax_env);
                    matlab1.mmaxbtfax_env = (MWNumericArray) matlab1.matvec[16];
                    matlab1.maxbtfax_env[i] = matlab1.mmaxbtfax_env.getDouble();
                    MWArray.disposeArray(matlab1.mmaxbtfax_env);
                    matlab1.mmaxbtfax = (MWNumericArray) matlab1.matvec[15];
                    matlab1.maxbtfax[i] = matlab1.mmaxbtfax.getDoubleData();
                    MWArray.disposeArray(matlab1.mmaxbtfax);
                    matlab1.mmaxbtf = (MWNumericArray) matlab1.matvec[14];
                    matlab1.maxbtf[i] = matlab1.mmaxbtf.getDoubleData();
                    MWArray.disposeArray(matlab1.mmaxbtf);

                    matvec1 = matlab1.matte.java_get_plotdata(5);
                    matlab1.mplotmaxfint = (MWNumericArray) matvec1[0];
                    matlab1.plotmaxfint = matlab1.mplotmaxfint.getDouble();
                    MWArray.disposeArray(matlab1.mplotmaxfint);
                    matlab1.mplotmaxbtf = (MWNumericArray) matvec1[1];
                    matlab1.plotmaxbtf = matlab1.mplotmaxbtf.getDouble();
                    MWArray.disposeArray(matlab1.mplotmaxbtf);
                    matlab1.mplotminbtf = (MWNumericArray) matvec1[2];
                    matlab1.plotminbtf = matlab1.mplotminbtf.getDouble();
                    MWArray.disposeArray(matlab1.mplotminbtf);
                    matlab1.mplotmaxkinf = (MWNumericArray) matvec1[3];
                    matlab1.plotmaxkinf = matlab1.mplotmaxkinf.getDouble();
                    MWArray.disposeArray(matlab1.mplotmaxkinf);
                    matlab1.mplotminkinf = (MWNumericArray) matvec1[4];
                    matlab1.plotminkinf = matlab1.mplotminkinf.getDouble();
                    MWArray.disposeArray(matlab1.mplotminkinf);

                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        }
        mainpanel1.fint_str = mainpanel1.df3.format(matlab1.fint[mainpanel1.cn][mainpanel1.burnupslider.getValue()]);
        if (mainpanel1.axial_btf_check.isSelected() && mainpanel1.fkinf_check.isSelected()) {
            mainpanel1.btf_str = "  <BTF(kinf)> = " + mainpanel1.df3.format(matlab1.maxbtfax_env[mainpanel1.cn]);
        } else if (mainpanel1.axial_btf_check.isSelected()) {
            mainpanel1.btf_str = "  <BTF> = " + mainpanel1.df3.format(matlab1.maxbtfax[mainpanel1.cn][mainpanel1.burnupslider.getValue()]);
        } else {
            mainpanel1.btf_str = "  BTF = " + mainpanel1.df3.format(matlab1.maxbtf[mainpanel1.cn][mainpanel1.burnupslider.getValue()]);
        }

        mainpanel1.point_message.setText("Burnup = " + matlab1.burnup[mainpanel1.cn][mainpanel1.burnupslider.getValue()]
                + "   kinf = " + matlab1.kinf[mainpanel1.cn][mainpanel1.burnupslider.getValue()]
                + "   fint = " + mainpanel1.fint_str
                + mainpanel1.btf_str);

        mainpanel1.repaint();
    }

    public void calc_channel_bow_peanalty_vector() {

        int m = 0;
        int i = 0;
        while (m < matlab1.Nburnup[0]) {
            if (matlab1.burnup[0][m] == 0) {
                bur_index[i] = m;
                i++;
            } else if (matlab1.burnup[0][m] == 2.0) {
                bur_index[i] = m;
                i++;
            } else if (matlab1.burnup[0][m] == 5.0) {
                bur_index[i] = m;
                i++;
            } else if (matlab1.burnup[0][m] == 7.0) {
                bur_index[i] = m;
                i++;
            } else if (matlab1.burnup[0][m] == 10.0) {
                bur_index[i] = m;
                i++;
            } else if (matlab1.burnup[0][m] == 15.0) {
                bur_index[i] = m;
                i++;
            }
            m++;
        }


        if (mainpanel1.axial_btf_check.isSelected()) {

// No bowing
            for (int j = 0; j < 6; j++) {
                btf_0[j] = matlab1.maxbtfax[mainpanel1.cn][bur_index[j]];
//                System.out.println(btf_0[j]);
            }
            mainpanel1.update();


// Bowing 0 mm towards CRD
            for (i = 0; i <= mainpanel1.cnmax; i++) {
                try {
                    matlab1.matte.java_calcbow(i + 1, 0.0);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
            try {
                matlab1.matvec = matlab1.matte.java_calcbtfax(1);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, 1);
                matlab1.mmaxbtfax = (MWNumericArray) matlab1.matvec[15];
                matlab1.maxbtfax[mainpanel1.cn] = matlab1.mmaxbtfax.getDoubleData();
                MWArray.disposeArray(matlab1.mmaxbtfax);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            for (int j = 0; j < 6; j++) {
                btf_0[j] = matlab1.maxbtfax[mainpanel1.cn][bur_index[j]];
//                System.out.println(btf_2[j]);
            }
            mainpanel1.update();




// Bowing 1 mm away from CRD
            mainpanel1.update();
            for (i = 0; i <= mainpanel1.cnmax; i++) {
                try {
                    matlab1.matte.java_calcbow(i + 1, 1.0);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
            try {
                matlab1.matvec = matlab1.matte.java_calcbtfax(1);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, 1);
                matlab1.mmaxbtfax = (MWNumericArray) matlab1.matvec[15];
                matlab1.maxbtfax[mainpanel1.cn] = matlab1.mmaxbtfax.getDoubleData();
                MWArray.disposeArray(matlab1.mmaxbtfax);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            for (int j = 0; j < 6; j++) {
                btf_1[j] = matlab1.maxbtfax[mainpanel1.cn][bur_index[j]];
//                System.out.println(btf_1[j]);
            }


            // Bowing 0 mm towards CRD
            for (i = 0; i <= mainpanel1.cnmax; i++) {
                try {
                    matlab1.matte.java_calcbow(i + 1, 0.0);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
            try {
                matlab1.matvec = matlab1.matte.java_calcbtfax(1);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, 1);
                matlab1.mmaxbtfax = (MWNumericArray) matlab1.matvec[15];
                matlab1.maxbtfax[mainpanel1.cn] = matlab1.mmaxbtfax.getDoubleData();
                MWArray.disposeArray(matlab1.mmaxbtfax);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            for (int j = 0; j < 6; j++) {
                btf_0[j] = matlab1.maxbtfax[mainpanel1.cn][bur_index[j]];
//                System.out.println(btf_2[j]);
            }
            mainpanel1.update();


// Bowing 1 mm towards CRD
            mainpanel1.update();
            for (i = 0; i <= mainpanel1.cnmax; i++) {
                try {
                    matlab1.matte.java_calcbow(i + 1, -1.0);
//                    matlab1.matte.java_calcbtf(i + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
            try {
                matlab1.matvec = matlab1.matte.java_calcbtfax(1);
                matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, 1);
                matlab1.mmaxbtfax = (MWNumericArray) matlab1.matvec[15];
                matlab1.maxbtfax[mainpanel1.cn] = matlab1.mmaxbtfax.getDoubleData();
                MWArray.disposeArray(matlab1.mmaxbtfax);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
            for (int j = 0; j < 6; j++) {
                btf_2[j] = matlab1.maxbtfax[mainpanel1.cn][bur_index[j]];
//                System.out.println(btf_2[j]);
            }
            mainpanel1.update();

        }



    }
}
