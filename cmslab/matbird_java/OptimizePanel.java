/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.studsvik;


import com.mathworks.toolbox.javabuilder.MWApplication;
import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;

import org.openide.util.Exceptions;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;

import java.text.DecimalFormat;

import javax.swing.BorderFactory;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.JTextField;
import javax.swing.SpinnerNumberModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;


/**
 * @author  kjell
 */
public class OptimizePanel extends JPanel
{
    public MainPanel mainpanel1;
    public MatLab matlab1;
    JPanel buttonPanel1;
    JPanel buttonPanel2;
    JPanel buttonPanel3;
    JPanel casePanel;
    JPanel finttargetPanel1;
    JPanel finttargetPanel2;
    JPanel finttargetPanel3;
    JPanel finttargetPanel4;
    JPanel btftargetPanel1;
    JPanel btftargetPanel2;
    JPanel btftargetPanel3;
    JPanel btftargetPanel4;
    JPanel tmolPanel1;
    JPanel tmolPanel2;
    JPanel tmolPanel3;
    JPanel messagePanel;
    JPanel showoptPanel;
    private JLabel typelabel;
    private JLabel u235targetlabel;
    private JLabel case_numberlabel;
    private JLabel finttargetlabel1;
    private JLabel finttargetlabel2;
    private JLabel finttargetlabel3;
    private JLabel finttargetlabel4;
    private JLabel btftargetlabel1;
    private JLabel btftargetlabel2;
    private JLabel btftargetlabel3;
    private JLabel btftargetlabel4;
    private JLabel tmollabel1;
    private JLabel maxburnuplabel;
    private JLabel messagelabel1;
    private JLabel messagelabel2;
    private JLabel messagelabel3;
    private JLabel showoptlabel;
    private JLabel radialnumberlabel;
    private JTextField finttargettextfield1b;
    private JTextField finttargettextfield2b;
    private JTextField finttargettextfield3b;
    private JTextField finttargettextfield4b;
    private JTextField finttargettextfield5b;
    private JTextField finttargettextfield1f;
    private JTextField finttargettextfield2f;
    private JTextField finttargettextfield3f;
    private JTextField finttargettextfield4f;
    private JTextField finttargettextfield5f;
    private JTextField btftargettextfield1b;
    private JTextField btftargettextfield2b;
    private JTextField btftargettextfield3b;
    private JTextField btftargettextfield4b;
    private JTextField btftargettextfield5b;
    private JTextField btftargettextfield1f;
    private JTextField btftargettextfield2f;
    private JTextField btftargettextfield3f;
    private JTextField btftargettextfield4f;
    private JTextField btftargettextfield5f;
    private JTextField u235targetextfield;
    private JTextField maxburnuptextfield;
    private JTextField radialnumbertextfield;
    private JCheckBox btf_target_check;
    private JCheckBox tmol_corner_check;
    private JCheckBox plr_corner_check;
    private JCheckBox ba_check;
    private JCheckBox autba_check;
    private JCheckBox selrods_check;
    private JCheckBox showopt_check;
    private JTextField cornertextfield;
    private JTextField plrtextfield;
    private JTextField barodtextfield;
    private JTextField maxfinttextfield;
    private JTextField maxbtftextfield;
    Object[] matvec = null;
    Object[] matvec1 = null;
    int m, ok;
    String u235_str;
    Number nr;
    int spinnervalue;
    double u235target;
    DecimalFormat df2 = new DecimalFormat("0.00");
    DecimalFormat df0 = new DecimalFormat("#");
    public MatLab[] matlab;
    int top_nr1;
    Object matvec2;
    static int nr_radial_times = 10;
    MWNumericArray mok;

    /**
     * Creates a new OptimizePanel object.
     *
     * @param  mainpanelx  DOCUMENT ME!
     * @param  matlabx  DOCUMENT ME!
     * @param  top_nr  DOCUMENT ME!
     */
    public OptimizePanel(MainPanel mainpanelx, MatLab matlabx, int top_nr) {
        setBackground(Color.white);
//        setBackground(new Color(255, 255, 210));
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);
        setPreferredSize(new Dimension(650, 400));
        Font font_spinner = new Font("Times New Roman", Font.BOLD, 12);
        Dimension dim = new Dimension(130, 30);
        Dimension dim_spinner = new Dimension(45, 25);
        Dimension dim_textb = new Dimension(35, 20);
        Dimension dim_textf = new Dimension(45, 20);

        top_nr1 = top_nr;
        matlab1 = matlabx;
        mainpanel1 = mainpanelx;

        buttonPanel1 = new JPanel();
        buttonPanel1.setBackground(Color.white);
//        buttonPanel1.setBackground(Color.green);
        buttonPanel1.setBounds(20, 15, 140, 200);
        add(buttonPanel1);

        typelabel = new JLabel("Start Optimize");
        typelabel.setFont(mainpanel1.font_button);
        buttonPanel1.add(typelabel);

        javax.swing.JButton radialones = new javax.swing.JButton("Radial ");
        radialones.setFont(mainpanel1.font_button);
        radialones.setPreferredSize(dim);
        buttonPanel1.add(radialones);
        radialones.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                int counter = 0;

                for (int k = 0; k < 40; k++) {
                    counter = k + 1;
                    messagelabel1.setText("Radial optimizing status " + k + " of max "+ 40);

                    radial_optimizing(top_nr1);
                    try {
                        matvec = matlab1.matte.java_get_radial_opt(1);
                        mok = (MWNumericArray) matvec[0];
                        ok = mok.getInt();


                        //                        System.gc();
                        //                        System.runFinalization();
                    } catch (MWException ex) {
                        Exceptions.printStackTrace(ex);
                    }

                    if (ok == 1) {
                        break;
                    }
                }


                messagelabel1.setText("Radial optimizing status " + counter + " of max "+ 40);
                mainpanel1.repaint();
            }
        });

        javax.swing.JButton radial5times = new javax.swing.JButton("Radial x times");
        radial5times.setFont(mainpanel1.font_button);
        radial5times.setPreferredSize(dim);
        buttonPanel1.add(radial5times);
        radial5times.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                int counter = 0;

                    for (int k = 0; k < nr_radial_times; k++)
                    {
                        counter = k + 1;
                        messagelabel1.setText("Radial optimizing status " + k + " of " + nr_radial_times);
                        radial_optimizing(top_nr1);
                        mainpanel1.repaint();
//                        System.gc();
//                        System.runFinalization();
                    }

                    messagelabel1.setText("Radial optimizing status " + counter + " of " + nr_radial_times);
                    mainpanel1.repaint();
                }
            });


        radialnumbertextfield = new JTextField();
        radialnumbertextfield.setPreferredSize(new Dimension(30, 25));
        radialnumbertextfield.setFont(mainpanel1.font_button);
        radialnumbertextfield.setHorizontalAlignment(4);
        radialnumbertextfield.setText(mainpanel1.df0.format(nr_radial_times));
        buttonPanel1.add(radialnumbertextfield);
        radialnumbertextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = radialnumbertextfield.getText();
                    nr_radial_times = Integer.valueOf(str);
                }
            });

        radialnumberlabel = new JLabel("radial times");
        radialnumberlabel.setFont(font_spinner);
        buttonPanel1.add(radialnumberlabel);


        javax.swing.JButton u235ones = new javax.swing.JButton("U235 ones");
        u235ones.setFont(mainpanel1.font_button);
        u235ones.setPreferredSize(dim);
        buttonPanel1.add(u235ones);
        u235ones.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    enr_optimizing(top_nr1);
                    mainpanel1.repaint();
                }
            });

        javax.swing.JButton radialplusu235 = new javax.swing.JButton("Radial + U235");
        radialplusu235.setFont(mainpanel1.font_button);
        radialplusu235.setPreferredSize(dim);
        buttonPanel1.add(radialplusu235);
        radialplusu235.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    int counter = 0;
                    messagelabel2.setText("U235 optimizing status 0");
                    messagelabel3.setText("Radial+U235 optimizing status " + 0 + " of " + 3);

                    for (int k = 0; k < 5; k++)
                    {
                        counter = k + 1;
                        messagelabel1.setText("Radial optimizing status " + k + " of " + 5);
                        radial_optimizing(top_nr1);
                        mainpanel1.repaint();
//                        System.gc();
//                        System.runFinalization();
                    }

                    for (int y = 0; y < 3; y++)
                    {
                        messagelabel3.setText("Radial + U235 optimizing status " + y + " of " + 3);
//                    int counter = 0;
                        for (int k = 0; k < 5; k++)
                        {
                            counter = k + 1;
                            messagelabel1.setText("Radial optimizing status " + k + " of " + 5);
                            radial_optimizing(top_nr1);
                            mainpanel1.repaint();
                        }

                        messagelabel1.setText("Radial optimizing status " + counter + " of " + 5);
                        enr_optimizing(top_nr1);
                    }

                    for (int k = 0; k < 3; k++)
                    {
                        counter = k + 1;
                        messagelabel1.setText("Radial optimizing status " + k + " of " + 3);
                        radial_optimizing(top_nr1);
                        mainpanel1.repaint();
//                        System.gc();
//                        System.runFinalization();

                    }

                    messagelabel1.setText("Radial optimizing status " + counter + " of " + 3);
                    messagelabel3.setText("Radial + U235 optimizing status " + 3 + " of " + 3);
                    mainpanel1.repaint();
                }
            });


        buttonPanel2 = new JPanel();
        buttonPanel2.setBackground(Color.white);
//        buttonPanel2.setBackground(Color.green);
        buttonPanel2.setBounds(175, 215, 150, 70);
        add(buttonPanel2);

//        Font font_spinner = new Font("Times New Roman", Font.BOLD, 12);

        u235targetlabel = new JLabel("U235 target");
        u235targetlabel.setFont(font_spinner);
        buttonPanel2.add(u235targetlabel);

        u235targetextfield = new JTextField();
        u235targetextfield.setPreferredSize(new Dimension(55, 25));
        u235targetextfield.setFont(mainpanel1.font_button);
        u235targetextfield.setHorizontalAlignment(4);
        u235targetextfield.setText(mainpanel1.df3.format(matlab1.mean_u235));
        buttonPanel2.add(u235targetextfield);
        u235targetextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = u235targetextfield.getText();
                    u235target = Double.valueOf(str);
                    System.out.println(u235target);
                    mainpanel1.repaint();
                }
            });
        u235target = matlab1.mean_u235;


        maxburnuplabel = new JLabel("Max burnup");
        maxburnuplabel.setFont(font_spinner);
        buttonPanel2.add(maxburnuplabel);

        maxburnuptextfield = new JTextField();
        maxburnuptextfield.setPreferredSize(new Dimension(55, 25));
        maxburnuptextfield.setFont(mainpanel1.font_button);
        maxburnuptextfield.setHorizontalAlignment(4);
        maxburnuptextfield.setText(mainpanel1.df0.format(matlab1.max_burnup[mainpanel1.cn]));
        buttonPanel2.add(maxburnuptextfield);
        maxburnuptextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = maxburnuptextfield.getText();
                    matlab1.max_burnup[mainpanel1.cn] = Double.valueOf(str);
//                    System.out.println(matlab1.max_burnup[mainpanel1.cn]);

                    for (m = 0; m <= mainpanel1.cnmax; m++)
                    {
                        try
                        {
                            matlab1.matte.java_set_max_burnup(mainpanel1.cn + 1,
                                matlab1.max_burnup[mainpanel1.cn]);
                        }
                        catch (MWException ex)
                        {
                            Exceptions.printStackTrace(ex);
                        }
                    }

                    mainpanel1.repaint();
                }
            });


        buttonPanel3 = new JPanel();
        buttonPanel3.setBackground(Color.white);
//        buttonPanel3.setBackground(Color.green);
        buttonPanel3.setBounds(20, 215, 140, 80);
        add(buttonPanel3);

//        typelabel = new JLabel("Start Optimize");
//        typelabel.setFont(mainpanel1.font_button);
//        buttonPanel3.add(typelabel);

        javax.swing.JButton resetbtfp = new javax.swing.JButton("Reset BTFP");
        resetbtfp.setFont(mainpanel1.font_button);
        resetbtfp.setPreferredSize(dim);
        buttonPanel3.add(resetbtfp);
        resetbtfp.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    try
                    {
                        matlab1.matte.java_reset_btfp();
                    }
                    catch (MWException ex)
                    {
                        Exceptions.printStackTrace(ex);
                    }

                    for (m = 0; m <= mainpanel1.cnmax; m++)
                    {
                        try
                        {
                            matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                        }
                        catch (MWException ex)
                        {
                            Exceptions.printStackTrace(ex);
                        }

                        MWNumericArray mbtfp = (MWNumericArray) matvec[21];
                        matlab1.btfp[m] = (double[][]) mbtfp.toDoubleArray();
                        MWArray.disposeArray(mbtfp);
                    }

                    mainpanel1.repaint();
                }
            });

        javax.swing.JButton resettmol = new javax.swing.JButton("Reset TMOL");
        resettmol.setFont(mainpanel1.font_button);
        resettmol.setPreferredSize(dim);
        buttonPanel3.add(resettmol);
        resettmol.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    try
                    {
                        for (m = 0; m <= mainpanel1.cnmax; m++)
                        {
                            matlab1.matte.java_reset_tmol(m + 1);
                        }
                    }
                    catch (MWException ex)
                    {
                        Exceptions.printStackTrace(ex);
                    }

                    for (m = 0; m <= mainpanel1.cnmax; m++)
                    {
                        try
                        {
                            matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                        }
                        catch (MWException ex)
                        {
                            Exceptions.printStackTrace(ex);
                        }

                        MWNumericArray mtmol = (MWNumericArray) matvec[22];
                        matlab1.tmol[m] = (double[][]) mtmol.toDoubleArray();
                        MWArray.disposeArray(mtmol);
                    }

                    mainpanel1.repaint();
                }
            });


        casePanel = new JPanel();
        casePanel.setBackground(Color.white);
//        casePanel.setBackground(Color.green);
        casePanel.setBounds(495, 270, 130, 40);
        add(casePanel);

        case_numberlabel = new JLabel("Case nr");
        case_numberlabel.setFont(font_spinner);
        casePanel.add(case_numberlabel);

        final SpinnerNumberModel casenumbermodel = new SpinnerNumberModel(mainpanel1.cn + 1, 1,
                mainpanel1.cnmax + 1, 1);
        JSpinner casenumberspinner = new JSpinner(casenumbermodel);
        casenumberspinner.setFont(font_spinner);
        casenumberspinner.setPreferredSize(dim_spinner);

//        nr = casenumbermodel.getNumber();
//        spinnervalue = nr.intValue();
        casePanel.add(casenumberspinner);

        casenumbermodel.addChangeListener(new ChangeListener()
            {
                @Override
                public void stateChanged(ChangeEvent e)
                {
                    Number nr = casenumbermodel.getNumber();
                    mainpanel1.cn = nr.intValue() - 1;
                    set_limits();
                    repaint();
                }
            });


        finttargetPanel1 = new JPanel();
        finttargetPanel1.setBackground(Color.white);
//        finttargetPanel1.setBackground(Color.green);
        finttargetPanel1.setBounds(495, 15, 130, 30);
        add(finttargetPanel1);

        finttargetlabel1 = new JLabel("fint target");
        finttargetlabel1.setFont(mainpanel1.font_button);
        finttargetPanel1.add(finttargetlabel1);

        finttargetPanel2 = new JPanel();
        finttargetPanel2.setBackground(Color.white);
//        finttargetPanel2.setBackground(Color.green);
        finttargetPanel2.setBounds(495, 50, 60, 160);
        add(finttargetPanel2);
        finttargetlabel2 = new JLabel("burnup");
        finttargetlabel2.setFont(mainpanel1.font_button);
        finttargetPanel2.add(finttargetlabel2);


        finttargettextfield1b = new JTextField();
        finttargettextfield1b.setPreferredSize(dim_textb);
        finttargettextfield1b.setFont(mainpanel1.font_button);
        finttargettextfield1b.setHorizontalAlignment(4);
        finttargettextfield1b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][0][0]));
        finttargetPanel2.add(finttargettextfield1b);
        finttargettextfield1b.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                String str;
                str = finttargettextfield1b.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][0][0] = Double.valueOf(str);
                try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }

                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield2b = new JTextField();
        finttargettextfield2b.setPreferredSize(dim_textb);
        finttargettextfield2b.setFont(mainpanel1.font_button);
        finttargettextfield2b.setHorizontalAlignment(4);
        finttargettextfield2b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][1][0]));
        finttargetPanel2.add(finttargettextfield2b);
        finttargettextfield2b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield2b.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][1][0] = Double.valueOf(str);
                                    try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield3b = new JTextField();
        finttargettextfield3b.setPreferredSize(dim_textb);
        finttargettextfield3b.setFont(mainpanel1.font_button);
        finttargettextfield3b.setHorizontalAlignment(4);
        finttargettextfield3b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][2][0]));
        finttargetPanel2.add(finttargettextfield3b);
        finttargettextfield3b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield3b.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][2][0] = Double.valueOf(str);
                                    try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield4b = new JTextField();
        finttargettextfield4b.setPreferredSize(dim_textb);
        finttargettextfield4b.setFont(mainpanel1.font_button);
        finttargettextfield4b.setHorizontalAlignment(4);
        finttargettextfield4b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][3][0]));
        finttargetPanel2.add(finttargettextfield4b);
        finttargettextfield4b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield4b.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][3][0] = Double.valueOf(str);
                                    try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield5b = new JTextField();
        finttargettextfield5b.setPreferredSize(dim_textb);
        finttargettextfield5b.setFont(mainpanel1.font_button);
        finttargettextfield5b.setHorizontalAlignment(4);
        finttargettextfield5b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][4][0]));
        finttargetPanel2.add(finttargettextfield5b);
        finttargettextfield5b.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                String str;
                str = finttargettextfield5b.getText();
                matlab1.max_fint_tab[mainpanel1.cn][4][0] = Double.valueOf(str);
                try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                System.out.println(str);
                mainpanel1.repaint();
            }
        });


        finttargetPanel3 = new JPanel();
        finttargetPanel3.setBackground(Color.white);
//        finttargetPanel3.setBackground(Color.green);
        finttargetPanel3.setBounds(560, 50, 65, 160);
        add(finttargetPanel3);
        finttargetlabel3 = new JLabel("max fint");
        finttargetlabel3.setFont(mainpanel1.font_button);
        finttargetPanel3.add(finttargetlabel3);

        finttargettextfield1f = new JTextField();
        finttargettextfield1f.setPreferredSize(dim_textf);
        finttargettextfield1f.setFont(mainpanel1.font_button);
        finttargettextfield1f.setHorizontalAlignment(4);
        finttargettextfield1f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][0][1]));
        finttargetPanel3.add(finttargettextfield1f);
        finttargettextfield1f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield1f.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][0][1] = Double.valueOf(str);
                try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield2f = new JTextField();
        finttargettextfield2f.setPreferredSize(dim_textf);
        finttargettextfield2f.setFont(mainpanel1.font_button);
        finttargettextfield2f.setHorizontalAlignment(4);
        finttargettextfield2f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][1][1]));
        finttargetPanel3.add(finttargettextfield2f);
        finttargettextfield2f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield2f.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][1][1] = Double.valueOf(str);
                try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield3f = new JTextField();
        finttargettextfield3f.setPreferredSize(dim_textf);
        finttargettextfield3f.setFont(mainpanel1.font_button);
        finttargettextfield3f.setHorizontalAlignment(4);
        finttargettextfield3f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][2][1]));
        finttargetPanel3.add(finttargettextfield3f);
        finttargettextfield3f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield3f.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][2][1] = Double.valueOf(str);
                try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield4f = new JTextField();
        finttargettextfield4f.setPreferredSize(dim_textf);
        finttargettextfield4f.setFont(mainpanel1.font_button);
        finttargettextfield4f.setHorizontalAlignment(4);
        finttargettextfield4f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][3][1]));
        finttargetPanel3.add(finttargettextfield4f);
        finttargettextfield4f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield4f.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][3][1] = Double.valueOf(str);
                 try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargettextfield5f = new JTextField();
        finttargettextfield5f.setPreferredSize(dim_textf);
        finttargettextfield5f.setFont(mainpanel1.font_button);
        finttargettextfield5f.setHorizontalAlignment(4);
        finttargettextfield5f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][4][1]));
        finttargetPanel3.add(finttargettextfield5f);
        finttargettextfield5f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = finttargettextfield5f.getText();
                    matlab1.max_fint_tab[mainpanel1.cn][4][1] = Double.valueOf(str);
                 try {
                    matlab1.matte.java_calc_maxfint_tab(mainpanel1.cn + 1, matlab1.max_fint_tab[mainpanel1.cn]);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        finttargetPanel4 = new JPanel();
        finttargetPanel4.setBackground(Color.white);
//        finttargetPanel4.setBackground(Color.green);
        finttargetPanel4.setBounds(495, 220, 130, 35);
        add(finttargetPanel4);
        finttargetlabel4 = new JLabel("max fint");
        finttargetlabel4.setFont(mainpanel1.font_button);
        finttargetPanel4.add(finttargetlabel4);
        maxfinttextfield = new JTextField();
        maxfinttextfield.setPreferredSize(dim_textf);
        maxfinttextfield.setFont(mainpanel1.font_button);
        maxfinttextfield.setHorizontalAlignment(4);
        maxfinttextfield.setText(df2.format(matlab1.maxfint[mainpanel1.cn]));
        finttargetPanel4.add(maxfinttextfield);
        maxfinttextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = maxfinttextfield.getText();
                    matlab1.maxfint[mainpanel1.cn] = Double.valueOf(str);
//                System.out.println(matlab1.maxfint[mainpanel1.cn]);
                    for (m = 0; m <= mainpanel1.cnmax; m++)
                    {
                        for (int i = 0; i < 5; i++)
                        {
                            matlab1.max_fint_tab[m][i][1] = matlab1.maxfint[mainpanel1.cn];
                        }
                    }

                    set_limits();
                    mainpanel1.repaint();
                }
            });


        btftargetPanel1 = new JPanel();
        btftargetPanel1.setBackground(Color.white);
//        btftargetPanel1.setBackground(Color.green);
        btftargetPanel1.setBounds(340, 15, 130, 30);
        add(btftargetPanel1);


        btftargetlabel1 = new JLabel("btf target");
        btftargetlabel1.setFont(mainpanel1.font_button);
        btftargetPanel1.add(btftargetlabel1);

        btf_target_check = new JCheckBox("", false);
        btf_target_check.setFont(mainpanel1.font_button);
        btftargetPanel1.add(btf_target_check);


        btftargetPanel2 = new JPanel();
        btftargetPanel2.setBackground(Color.white);

//        btftargetPanel2.setBackground(new Color(255, 255, 210));
//        btftargetPanel2.setBackground(Color.green);
        btftargetPanel2.setBounds(340, 50, 60, 160);
        add(btftargetPanel2);
        btftargetlabel2 = new JLabel("burnup");
        btftargetlabel2.setFont(mainpanel1.font_button);
        btftargetPanel2.add(btftargetlabel2);


        btftargettextfield1b = new JTextField();
        btftargettextfield1b.setPreferredSize(dim_textb);
        btftargettextfield1b.setFont(mainpanel1.font_button);
        btftargettextfield1b.setHorizontalAlignment(4);
        btftargettextfield1b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][0][0]));
        btftargetPanel2.add(btftargettextfield1b);
        btftargettextfield1b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield1b.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][0][0] = Double.valueOf(str);


                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield2b = new JTextField();
        btftargettextfield2b.setPreferredSize(dim_textb);
        btftargettextfield2b.setFont(mainpanel1.font_button);
        btftargettextfield2b.setHorizontalAlignment(4);
        btftargettextfield2b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][1][0]));
        btftargetPanel2.add(btftargettextfield2b);
        btftargettextfield2b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield2b.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][1][0] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield3b = new JTextField();
        btftargettextfield3b.setPreferredSize(dim_textb);
        btftargettextfield3b.setFont(mainpanel1.font_button);
        btftargettextfield3b.setHorizontalAlignment(4);
        btftargettextfield3b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][2][0]));
        btftargetPanel2.add(btftargettextfield3b);
        btftargettextfield3b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield3b.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][2][0] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield4b = new JTextField();
        btftargettextfield4b.setPreferredSize(dim_textb);
        btftargettextfield4b.setFont(mainpanel1.font_button);
        btftargettextfield4b.setHorizontalAlignment(4);
        btftargettextfield4b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][3][0]));
        btftargetPanel2.add(btftargettextfield4b);
        btftargettextfield4b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield4b.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][3][0] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield5b = new JTextField();
        btftargettextfield5b.setPreferredSize(dim_textb);
        btftargettextfield5b.setFont(mainpanel1.font_button);
        btftargettextfield5b.setHorizontalAlignment(4);
        btftargettextfield5b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][4][0]));
        btftargetPanel2.add(btftargettextfield5b);
        btftargettextfield5b.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield5b.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][4][0] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargetPanel3 = new JPanel();
        btftargetPanel3.setBackground(Color.white);
//        btftargetPanel3.setBackground(Color.green);
        btftargetPanel3.setBounds(405, 50, 65, 160);
        add(btftargetPanel3);
        btftargetlabel3 = new JLabel("max btf");
        btftargetlabel3.setFont(mainpanel1.font_button);
        btftargetPanel3.add(btftargetlabel3);


        btftargettextfield1f = new JTextField();
        btftargettextfield1f.setPreferredSize(dim_textf);
        btftargettextfield1f.setFont(mainpanel1.font_button);
        btftargettextfield1f.setHorizontalAlignment(4);
        btftargettextfield1f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][0][1]));
        btftargetPanel3.add(btftargettextfield1f);
        btftargettextfield1f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield1f.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][0][1] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield2f = new JTextField();
        btftargettextfield2f.setPreferredSize(dim_textf);
        btftargettextfield2f.setFont(mainpanel1.font_button);
        btftargettextfield2f.setHorizontalAlignment(4);
        btftargettextfield2f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][1][1]));
        btftargetPanel3.add(btftargettextfield2f);
        btftargettextfield2f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield2f.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][1][1] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield3f = new JTextField();
        btftargettextfield3f.setPreferredSize(dim_textf);
        btftargettextfield3f.setFont(mainpanel1.font_button);
        btftargettextfield3f.setHorizontalAlignment(4);
        btftargettextfield3f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][2][1]));
        btftargetPanel3.add(btftargettextfield3f);
        btftargettextfield3f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield3f.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][2][1] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield4f = new JTextField();
        btftargettextfield4f.setPreferredSize(dim_textf);
        btftargettextfield4f.setFont(mainpanel1.font_button);
        btftargettextfield4f.setHorizontalAlignment(4);
        btftargettextfield4f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][3][1]));
        btftargetPanel3.add(btftargettextfield4f);
        btftargettextfield4f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield4f.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][3][1] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });

        btftargettextfield5f = new JTextField();
        btftargettextfield5f.setPreferredSize(dim_textf);
        btftargettextfield5f.setFont(mainpanel1.font_button);
        btftargettextfield5f.setHorizontalAlignment(4);
        btftargettextfield5f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][4][1]));
        btftargetPanel3.add(btftargettextfield5f);
        btftargettextfield5f.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = btftargettextfield5f.getText();
                    matlab1.max_btf_tab[mainpanel1.cn][4][1] = Double.valueOf(str);
                    System.out.println(str);
                    mainpanel1.repaint();
                }
            });


        btftargetPanel4 = new JPanel();
        btftargetPanel4.setBackground(Color.white);
//        btftargetPanel4.setBackground(Color.green);
        btftargetPanel4.setBounds(340, 220, 130, 35);
        add(btftargetPanel4);
        btftargetlabel4 = new JLabel("max BTF");
        btftargetlabel4.setFont(mainpanel1.font_button);
        btftargetPanel4.add(btftargetlabel4);
        maxbtftextfield = new JTextField();
        maxbtftextfield.setPreferredSize(dim_textf);
        maxbtftextfield.setFont(mainpanel1.font_button);
        maxbtftextfield.setHorizontalAlignment(4);
        maxbtftextfield.setText(df2.format(matlab1.maxbtf_limit[mainpanel1.cn]));
        btftargetPanel4.add(maxbtftextfield);
        maxbtftextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = maxbtftextfield.getText();
                    matlab1.maxbtf_limit[mainpanel1.cn] = Double.valueOf(str);
//                System.out.println(matlab1.maxfint[mainpanel1.cn]);
                    for (m = 0; m <= mainpanel1.cnmax; m++)
                    {
                        for (int i = 0; i < 5; i++)
                        {
                            matlab1.max_btf_tab[m][i][1] = matlab1.maxbtf_limit[mainpanel1.cn];
                        }
                    }

                    set_limits();
                    mainpanel1.repaint();
                }
            });


        tmolPanel1 = new JPanel();
        tmolPanel1.setBackground(Color.white);
//        tmolPanel1.setBackground(Color.green);
        tmolPanel1.setBounds(185, 15, 130, 30);
        add(tmolPanel1);

        tmollabel1 = new JLabel("TMOL margin %");
        tmollabel1.setFont(mainpanel1.font_button);
        tmolPanel1.add(tmollabel1);

        tmolPanel2 = new JPanel();
        tmolPanel2.setBackground(Color.white);
//        tmolPanel2.setBackground(Color.green);
//        tmolPanel2.setBounds(185, 50, 90, 130);
        tmolPanel2.setBounds(165, 50, 110, 160);
        add(tmolPanel2);

        tmol_corner_check = new JCheckBox("Corner", false);
        tmol_corner_check.setFont(mainpanel1.font_button);
        tmol_corner_check.setPreferredSize(new Dimension(100, 25));
        tmol_corner_check.setHorizontalAlignment(2);
        tmolPanel2.add(tmol_corner_check);

        if (matlab1.corner_tmol[mainpanel1.cn] == 1)
        {
            tmol_corner_check.setSelected(true);
        }
        else
        {
            tmol_corner_check.setSelected(false);
        }

        tmol_corner_check.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    if (tmol_corner_check.isSelected())
                    {
                        matlab1.corner_tmol[mainpanel1.cn] = 1;
                    }
                    else
                    {
                        matlab1.corner_tmol[mainpanel1.cn] = 0;
                    }
//                System.out.println(matlab1.corner_tmol[mainpanel1.cn]);
//                mainpanel1.repaint();
                }
            });

        plr_corner_check = new JCheckBox("PLR", false);
        plr_corner_check.setFont(mainpanel1.font_button);
        plr_corner_check.setPreferredSize(new Dimension(100, 25));
        plr_corner_check.setHorizontalAlignment(2);
        tmolPanel2.add(plr_corner_check);

        if (matlab1.plr_tmol[mainpanel1.cn] == 1)
        {
            plr_corner_check.setSelected(true);
        }
        else
        {
            plr_corner_check.setSelected(false);
        }

        plr_corner_check.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    if (plr_corner_check.isSelected())
                    {
                        matlab1.plr_tmol[mainpanel1.cn] = 1;
                    }
                    else
                    {
                        matlab1.plr_tmol[mainpanel1.cn] = 0;
                    }
                }
            });


        ba_check = new JCheckBox("BA", false);
        ba_check.setFont(mainpanel1.font_button);
        ba_check.setPreferredSize(new Dimension(100, 25));
        ba_check.setHorizontalAlignment(2);
        tmolPanel2.add(ba_check);

        if (matlab1.ba_tmol[mainpanel1.cn] == 1)
        {
            ba_check.setSelected(true);
        }
        else
        {
            ba_check.setSelected(false);
        }

        ba_check.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    if (ba_check.isSelected())
                    {
                        matlab1.ba_tmol[mainpanel1.cn] = 1;
                    }
                    else
                    {
                        matlab1.ba_tmol[mainpanel1.cn] = 0;
                    }
                }
            });


        autba_check = new JCheckBox("Aut BA", true);
        autba_check.setFont(mainpanel1.font_button);
        autba_check.setPreferredSize(new Dimension(100, 25));
        autba_check.setHorizontalAlignment(2);
        tmolPanel2.add(autba_check);

        if (matlab1.aut_ba[mainpanel1.cn] == 1)
        {
            autba_check.setSelected(true);
        }
        else
        {
            autba_check.setSelected(false);
        }

        autba_check.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                if (autba_check.isSelected()) {
                    matlab1.aut_ba[mainpanel1.cn] = 1;
                    for (m = 0; m <= mainpanel1.cnmax; m++) {
                        try {
                            matlab1.matte.java_autba(m+1, 1);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                } else {
                    matlab1.aut_ba[mainpanel1.cn] = 0;
                    for (m = 0; m <= mainpanel1.cnmax; m++) {
                        try {
                            matlab1.matte.java_autba(m+1, 0);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
            }
        });


        selrods_check = new JCheckBox("Sel Rods", true);
        selrods_check.setFont(mainpanel1.font_button);
        selrods_check.setPreferredSize(new Dimension(100, 25));
        selrods_check.setHorizontalAlignment(2);
        tmolPanel2.add(selrods_check);

        if (matlab1.sel_rods[mainpanel1.cn] == 1)
        {
            selrods_check.setSelected(true);
        }
        else
        {
            selrods_check.setSelected(false);
        }

        selrods_check.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                if (selrods_check.isSelected()) {
                    matlab1.sel_rods[mainpanel1.cn] = 1;
                    for (m = 0; m <= mainpanel1.cnmax; m++) {
                        try {
                            matlab1.matte.java_selrods(m+1, 1);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                } else {
                    matlab1.sel_rods[mainpanel1.cn] = 0;
                    for (m = 0; m <= mainpanel1.cnmax; m++) {
                        try {
                            matlab1.matte.java_selrods(m+1, 0);
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
            }
        });


        tmolPanel3 = new JPanel();
        tmolPanel3.setBackground(Color.white);
//        tmolPanel3.setBackground(Color.green);
        tmolPanel3.setBounds(280, 50, 37, 130);
        add(tmolPanel3);

        cornertextfield = new JTextField();
        cornertextfield.setPreferredSize(new Dimension(30, 25));
        cornertextfield.setFont(mainpanel1.font_button);
        cornertextfield.setHorizontalAlignment(4);
        cornertextfield.setText(matlab1.df0.format(matlab1.max_fint_tab[mainpanel1.cn][0][0]));
        tmolPanel3.add(cornertextfield);

        cornertextfield.setText(df0.format(100 * (matlab1.corner_limit[mainpanel1.cn] - 1)));
        cornertextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = cornertextfield.getText();
                    matlab1.corner_limit[mainpanel1.cn] = 1 + (Double.valueOf(str) / 100);
//                System.out.println(matlab1.corner_limit[mainpanel1.cn]);
                }
            });


        plrtextfield = new JTextField();
        plrtextfield.setPreferredSize(new Dimension(30, 25));
        plrtextfield.setFont(mainpanel1.font_button);
        plrtextfield.setHorizontalAlignment(4);
        plrtextfield.setText(matlab1.df0.format(matlab1.max_fint_tab[mainpanel1.cn][0][0]));
        tmolPanel3.add(plrtextfield);

        plrtextfield.setText(df0.format(100 * (matlab1.plr_limit[mainpanel1.cn] - 1)));
        plrtextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = plrtextfield.getText();
                    matlab1.plr_limit[mainpanel1.cn] = 1 + (Double.valueOf(str) / 100);
//                System.out.println(matlab1.plr_limit[mainpanel1.cn]);
                }
            });


        barodtextfield = new JTextField();
        barodtextfield.setPreferredSize(new Dimension(30, 25));
        barodtextfield.setFont(mainpanel1.font_button);
        barodtextfield.setHorizontalAlignment(4);
        barodtextfield.setText(matlab1.df0.format(matlab1.max_fint_tab[mainpanel1.cn][0][0]));
        tmolPanel3.add(barodtextfield);

        barodtextfield.setText(df0.format(100 * (matlab1.ba_limit[mainpanel1.cn] - 1)));
        barodtextfield.addActionListener(new java.awt.event.ActionListener()
            {
                @Override
                public void actionPerformed(java.awt.event.ActionEvent evt)
                {
                    String str;
                    str = barodtextfield.getText();
                    matlab1.ba_limit[mainpanel1.cn] = 1 + (Double.valueOf(str) / 100);
//                System.out.println(matlab1.ba_limit[mainpanel1.cn]);
                }
            });


        messagePanel = new JPanel();
        messagePanel.setBackground(Color.white);
//        messagePanel.setBackground(Color.green);
        messagePanel.setBounds(20, 300, 300, 70);

        add(messagePanel);

//        messagelabel1 = new JLabel("Radial optimizing status");
        messagelabel1 = new JLabel(" ");
        messagelabel1.setFont(mainpanel1.font_button);
        messagelabel1.setHorizontalTextPosition(JLabel.LEFT);
        messagePanel.add(messagelabel1);

//        messagelabel2 = new JLabel("U235 optimizing status");
        messagelabel2 = new JLabel(" ");
        messagelabel2.setFont(mainpanel1.font_button);
        messagelabel2.setHorizontalTextPosition(JLabel.LEFT);
        messagePanel.add(messagelabel2);

//        messagelabel3 = new JLabel("Radial+U235 optimizing status");
        messagelabel3 = new JLabel(" ");
        messagelabel3.setFont(mainpanel1.font_button);
        messagelabel3.setHorizontalTextPosition(JLabel.LEFT);
        messagePanel.add(messagelabel3);


        showoptPanel = new JPanel();
        showoptPanel.setBackground(Color.white);
//        showoptPanel.setBackground(Color.green);
        showoptPanel.setBounds(340, 270, 150, 30);
        add(showoptPanel);

        showoptlabel = new JLabel("Show opt steps");
        showoptlabel.setFont(mainpanel1.font_button);
        showoptPanel.add(showoptlabel);

        showopt_check = new JCheckBox("", false);
        showopt_check.setFont(mainpanel1.font_button);
        showoptPanel.add(showopt_check);


    }


    /**
     * DOCUMENT ME!
     *
     * @param  top_nr1  DOCUMENT ME!
     */
    public void radial_optimizing(int top_nr1)
    {
        int k;
        double u1;
        int i1;
        int j1;
        int imax;
        int jmax;
        double u0 = 0.0;
        MainPanel.opt_top_comp[top_nr1] = top_nr1;

        MWNumericArray mbtfaxenv = null;
        MWNumericArray mlfu = null;
        MWNumericArray mmean_u235 = null;
        MWNumericArray menr = null;
        MWNumericArray mba = null;
        Object[] matvec = null;
        Object[] matvec1 = null;

//        System.out.println("Total Memory" + Runtime.getRuntime().totalMemory());
//        System.out.println("Free Memory" + Runtime.getRuntime().freeMemory());


        try
        {
            for (m = 0; m <= mainpanel1.cnmax; m++)
            {
                matlab1.matte.java_calc_maxfint_tab(m + 1, matlab1.max_fint_tab[m]);
                matlab1.matte.java_calc_maxbtf_tab(m + 1, matlab1.max_btf_tab[m]);
            }

            matlab1.matte.java_increase_u235();
            matvec = matlab1.matte.java_calc_mean_u235(1);
            mmean_u235 = (MWNumericArray) matvec[0];
//            matvec = null;
            matlab1.mean_u235 = mmean_u235.getDouble();
            MWArray.disposeArray(mmean_u235);
//            mmean_u235.dispose();
            u235_str = "<U235> = " + mainpanel1.df3.format(matlab1.mean_u235);
            mainpanel1.u235_message.setText(u235_str);
            matlab1.matDispose(matvec);


            for (m = 0; m <= mainpanel1.cnmax; m++)
            {
                if (mainpanel1.ax_check[m].isSelected())
                {
                    matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                    mlfu = (MWNumericArray) matvec[1];
//                    matvec = null;
                    matlab1.lfu[m] = (int[][]) mlfu.toIntArray();
                    MWArray.disposeArray(mlfu);
                    matlab1.matDispose(matvec);
//                    mlfu.dispose();
                }
            }

            k = 0;
            u1 = 999;
            i1 = 999;
            j1 = 999;

            while ((matlab1.mean_u235 > (u235target + 0.004)) && (k < 100))
            {
                matvec1 = matlab1.matte.java_calcbtfaxenv(3);
                mbtfaxenv = (MWNumericArray) matvec1[1];
                imax = mbtfaxenv.getInt();
                MWArray.disposeArray(mbtfaxenv);
//                mbtfaxenv.dispose();
                mbtfaxenv = (MWNumericArray) matvec1[2];

                // matvec1 = null;
                jmax = mbtfaxenv.getInt();

                // MWArray.disposeArray(mbtfaxenv);
                matlab1.matDispose(matvec1);
//                mbtfaxenv.dispose();
                for (m = 0; m <= mainpanel1.cnmax; m++)
                {
                    if (mainpanel1.ax_check[m].isSelected())
                    {
                        matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);
                        menr = (MWNumericArray) matvec[20];
                        matlab1.enr[m] = (double[][]) menr.toDoubleArray();
                        MWArray.disposeArray(menr);
//                        menr.dispose();
                        u0 = matlab1.enr[m][imax - 1][jmax - 1];
                        mba = (MWNumericArray) matvec[19];
                        matlab1.ba[m] = (double[][]) mba.toDoubleArray();

                        // MWArray.disposeArray(mba);
                        // matvec = null;
                        matlab1.matDispose(matvec);
//                        mba.dispose();
                    }
                }

                if ((u0 == u1) && (i1 == imax) && (j1 == jmax))
                {
                    if (matlab1.ba[mainpanel1.cn][imax - 1][jmax - 1] > 0)
                    {
                        matlab1.matte.java_decrease_u235_barod(imax, jmax);
                        matlab1.matte.java_calcbtfaxenv(3);
                    }
                    else
                    {
                        matlab1.matte.java_check_min_u235(imax, jmax);
                        matlab1.matte.java_calcbtfaxenv(3);
                    }
                }

                matlab1.matte.java_decrease_u235(imax, jmax);
                matvec = matlab1.matte.java_calc_mean_u235(1);

                mmean_u235 = (MWNumericArray) matvec[0];

                //matvec = null;
                matlab1.mean_u235 = mmean_u235.getDouble();

                //MWArray.disposeArray(mmean_u235);
                matlab1.matDispose(matvec);
                u235_str = "<U235> = " + mainpanel1.df3.format(matlab1.mean_u235);
                mainpanel1.u235_message.setText(u235_str);

                k = k + 1;
                i1 = imax;
                j1 = jmax;

                for (m = 0; m <= mainpanel1.cnmax; m++)
                {
                    if (mainpanel1.ax_check[m].isSelected())
                    {
                        matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, m + 1);

                        //menr = (MWNumericArray) matvec[20];
                        matlab1.enr[m] = (double[][]) ((MWNumericArray) matvec[20]).toDoubleArray();

                        matlab1.matDispose(matvec);

                        // MWArray.disposeArray(menr);
//                        menr.dispose();
                    }
                }

                u1 = matlab1.enr[mainpanel1.cn][i1 - 1][j1 - 1];
//                u1 = matlab1.enr[0][i1 - 1][j1 - 1];

                if (showopt_check.isSelected())
                {
                    mainpanel1.update();
                }

            }

            matlab1.matte.java_max_corner_fint();
            matlab1.matte.java_max_corner_tmol();
            matlab1.matte.java_calcbtfax(1);
            matlab1.matte.java_calcbtfaxenv(3);
            matlab1.matte.java_check_maxfint();

            if (btf_target_check.isSelected()) {
                matlab1.matte.java_check_maxbtf();
            }

            matlab1.matte.java_adjust_btfp();

            if (btf_target_check.isSelected()) {
                matlab1.matte.java_adjust_btfp_btf();
            }

            matlab1.matte.java_calcbtfax(1);
            matlab1.matte.java_calcbtfaxenv(3);
//            matlab1.matte.java_max_corner_fint();
//            matlab1.matte.java_max_corner_tmol();
            matlab1.matte.java_calc_tmol_limit(matlab1.ba_tmol, matlab1.plr_tmol,
                    matlab1.corner_tmol, matlab1.aut_ba, matlab1.ba_limit, matlab1.plr_limit,
                    matlab1.corner_limit);

            if (tmol_corner_check.isSelected() || plr_corner_check.isSelected()
                    || ba_check.isSelected() || autba_check.isSelected() || selrods_check.isSelected()) {
                matlab1.matte.java_adjust_tmol();
            }

            mainpanel1.update();
            MainPanel.opt_top_comp[top_nr1] = 0;
        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        }
        finally
        {
            MWArray.disposeArray(mmean_u235);
            MWArray.disposeArray(mlfu);
            MWArray.disposeArray(mbtfaxenv);
            MWArray.disposeArray(menr);
            MWArray.disposeArray(mba);

        }

    }

    /**
     * DOCUMENT ME!
     *
     * @param  matObject  DOCUMENT ME!
     */
//    private void matDispose(Object[] matObject)
//    {
//        for (int i = 0; i < matObject.length; i++)
//        {
//            MWArray.disposeArray(matObject[i]);
//        }
//    }

    /**
     * DOCUMENT ME!
     */
    public void set_limits()
    {
        finttargettextfield1b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][0][0]));
        finttargettextfield2b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][1][0]));
        finttargettextfield3b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][2][0]));
        finttargettextfield4b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][3][0]));
        finttargettextfield5b.setText(matlab1.df0.format(
                matlab1.max_fint_tab[mainpanel1.cn][4][0]));
        finttargettextfield1f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][0][1]));
        finttargettextfield2f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][1][1]));
        finttargettextfield3f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][2][1]));
        finttargettextfield4f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][3][1]));
        finttargettextfield5f.setText(df2.format(matlab1.max_fint_tab[mainpanel1.cn][4][1]));

        btftargettextfield1b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][0][0]));
        btftargettextfield2b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][1][0]));
        btftargettextfield3b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][2][0]));
        btftargettextfield4b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][3][0]));
        btftargettextfield5b.setText(matlab1.df0.format(matlab1.max_btf_tab[mainpanel1.cn][4][0]));
        btftargettextfield1f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][0][1]));
        btftargettextfield2f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][1][1]));
        btftargettextfield3f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][2][1]));
        btftargettextfield4f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][3][1]));
        btftargettextfield5f.setText(df2.format(matlab1.max_btf_tab[mainpanel1.cn][4][1]));

        barodtextfield.setText(df0.format(100 * (matlab1.ba_limit[mainpanel1.cn] - 1)));
        plrtextfield.setText(df0.format(100 * (matlab1.plr_limit[mainpanel1.cn] - 1)));
        cornertextfield.setText(df0.format(100 * (matlab1.corner_limit[mainpanel1.cn] - 1)));

    }

    /**
     * DOCUMENT ME!
     *
     * @param  top_nr1  DOCUMENT ME!
     */
    public void enr_optimizing(int top_nr1)
    {
        int mz;
        int mm;
        MainPanel.opt_top_comp[top_nr1] = top_nr1;

        try {
            matvec = matlab1.matte.java_enr_combinations(1);

            MWNumericArray mmz = (MWNumericArray) matvec[0];
            mz = mmz.getInt();
            MWArray.disposeArray(mmz);
            matlab1.matDispose(matvec);


            for (mm = 0; mm < mz; mm++) {
                messagelabel2.setText("U235 optimizing status " + mm + " of " + mz);
                matlab1.matte.java_enr_opt(mm + 1);
                messagelabel2.setText("U235 optimizing status " + mz + " of " + mz);

                if (showopt_check.isSelected()) {
                    mainpanel1.update();
                }
            }

            matlab1.matte.java_calc_tmol_limit(matlab1.ba_tmol, matlab1.plr_tmol,
                    matlab1.corner_tmol, matlab1.aut_ba, matlab1.ba_limit, matlab1.plr_limit,
                    matlab1.corner_limit);
            mainpanel1.update();
        }
        catch (MWException ex)
        {
            Exceptions.printStackTrace(ex);
        }

        mainpanel1.update();
        MainPanel.opt_top_comp[top_nr1] = 0;
    }




} // end class OptimizePanel
