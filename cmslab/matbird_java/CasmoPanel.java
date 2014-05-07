/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWException;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import javax.swing.BorderFactory;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
public class CasmoPanel extends JPanel {

    public MainPanel mainpanel1;
    public MatLab matlab1;
    Object[] matvec;
    Object[] matvec1;
    String str;
    JCheckBox constdep_check;
    Dimension dim_textfield = new Dimension(380, 25);
    Dimension dim_textfield1 = new Dimension(280, 25);
    Dimension dim_label = new Dimension(70, 25);
    Dimension dim_label1 = new Dimension(90, 25);
    int casenr;
    JTextField c4eversiontextfield;
    JTextField c4eneulibtextfield;
    JTextField c4versiontextfield;
    JTextField c4neulibtextfield;
    JCheckBox c4_check;
    JCheckBox c4e_check;
    String version;
    String neulib;
    String option;

    public CasmoPanel(MainPanel mainpanel, MatLab matlab) {

        matlab1 = matlab;
        mainpanel1 = mainpanel;
        option = String.valueOf("-ke");
        neulib = String.valueOf("/cms/CasLib/library/j20200");
        version = String.valueOf("2.10.20P_SNF");

        setBackground(Color.white);
//        setBackground(new Color(255, 255, 210));
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);
        setPreferredSize(new Dimension(500, 400));

        JPanel panel1 = new JPanel();
        panel1.setBackground(Color.white);
//        panel1.setBackground(Color.green);
        panel1.setBounds(10, 300, 450, 40);
        add(panel1);


        javax.swing.JButton startcasmo = new javax.swing.JButton("Start Casmo");
        startcasmo.setFont(mainpanel1.font_button);
        panel1.add(startcasmo);

        startcasmo.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {
                    matvec = matlab1.matte.java_start_casmo(mainpanel1.cn + 1,option,neulib,version);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });

        javax.swing.JButton writecaifile = new javax.swing.JButton("Write caifile");
        writecaifile.setFont(mainpanel1.font_button);
        panel1.add(writecaifile);

        writecaifile.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {

                    if (constdep_check.isSelected()) {
                        matvec = matlab1.matte.java_writecaifile(mainpanel1.cn + 1, 1);
                    } else {
                        matvec = matlab1.matte.java_writecaifile(mainpanel1.cn + 1, 0);
                    }
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });

        javax.swing.JButton readcaxfile = new javax.swing.JButton("Read caxfile");
        readcaxfile.setFont(mainpanel1.font_button);
        panel1.add(readcaxfile);

        readcaxfile.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {
                    matlab1.matte.java_read_caxfile(mainpanel1.cn + 1, matlab1.caxfile[mainpanel1.cn]);
                    matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, mainpanel1.cn + 1);
                    MWCharArray mcaifile = (MWCharArray) matvec[32];
                    matlab1.caifile[mainpanel1.cn] = mcaifile.toString();
                    MWArray.disposeArray(mcaifile);
                    mainpanel1.caifiletextfield.setText(matlab1.caifile[mainpanel1.cn]);
                    mainpanel1.update();
                    mainpanel1.repaint();
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });

        constdep_check = new JCheckBox("const DEP", true);
        constdep_check.setFont(new Font("Times New Roman", Font.BOLD, 14));
        panel1.add(constdep_check);


        JPanel panel2 = new JPanel();
        panel2.setBackground(Color.white);
//        panel2.setBackground(Color.green);
        panel2.setBounds(10, 10, 65, 70);
        add(panel2);

        JLabel caxfile = new JLabel("cax file", JLabel.CENTER);
        caxfile.setPreferredSize(dim_label);
        caxfile.setForeground(Color.black);
        caxfile.setFont(mainpanel1.font_button);
        caxfile.setHorizontalAlignment(0);
        caxfile.setBackground(new Color(255, 255, 200));
        panel2.add(caxfile);

        JLabel inpfile = new JLabel("inp file", JLabel.CENTER);
        inpfile.setPreferredSize(dim_label);
        inpfile.setForeground(Color.black);
        inpfile.setFont(mainpanel1.font_button);
        inpfile.setHorizontalAlignment(0);
        inpfile.setBackground(new Color(255, 255, 200));
        panel2.add(inpfile);

        JPanel panel5 = new JPanel();
        panel5.setBackground(Color.white);
//        panel5.setBackground(Color.red);
        panel5.setBounds(10, 100, 100, 70);
        add(panel5);

        JLabel versionlabel = new JLabel("C4E version", JLabel.LEFT);
        versionlabel.setPreferredSize(dim_label1);
        versionlabel.setForeground(Color.black);
        versionlabel.setFont(mainpanel1.font_button);
        versionlabel.setHorizontalAlignment(0);
        versionlabel.setBackground(new Color(255, 255, 200));
        panel5.add(versionlabel);

        JLabel neuliblabel = new JLabel("C4E neulib ", JLabel.LEFT);
        neuliblabel.setPreferredSize(dim_label1);
        neuliblabel.setForeground(Color.black);
        neuliblabel.setFont(mainpanel1.font_button);
        neuliblabel.setHorizontalAlignment(0);
        neuliblabel.setBackground(new Color(255, 255, 200));
        panel5.add(neuliblabel);



        JPanel panel3 = new JPanel();
        panel3.setBackground(Color.white);
//        panel3.setBackground(Color.yellow);
        panel3.setBounds(85, 10, 390, 70);
        add(panel3);

        mainpanel1.caxfiletextfield.setPreferredSize(dim_textfield);
        mainpanel1.caxfiletextfield.setFont(mainpanel1.font_button);
        mainpanel1.caxfiletextfield.setHorizontalAlignment(2);
        mainpanel1.caxfiletextfield.setText(matlab1.caxfile[mainpanel1.cn]);
        panel3.add(mainpanel1.caxfiletextfield);
        mainpanel1.caxfiletextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                matlab1.caxfile[mainpanel1.cn] = mainpanel1.caxfiletextfield.getText();
                try {
                    matvec = matlab1.matte.java_change_caxfile(mainpanel1.cn + 1, mainpanel1.caxfiletextfield.getText());
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
            }
        });

        mainpanel1.caifiletextfield.setPreferredSize(dim_textfield);
        mainpanel1.caifiletextfield.setFont(mainpanel1.font_button);
        mainpanel1.caifiletextfield.setHorizontalAlignment(2);
        mainpanel1.caifiletextfield.setText(matlab1.caifile[mainpanel1.cn]);
        panel3.add(mainpanel1.caifiletextfield);
        mainpanel1.caifiletextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                matlab1.caifile[mainpanel1.cn] = mainpanel1.caifiletextfield.getText();
                try {
                    matvec = matlab1.matte.java_change_caifile(mainpanel1.cn + 1, mainpanel1.caifiletextfield.getText());
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }

            }
        });


        JPanel panel6 = new JPanel();
        panel6.setBackground(Color.white);
//        panel6.setBackground(Color.gray);
        panel6.setBounds(120, 100, 290, 70);
        add(panel6);

        c4eversiontextfield = new JTextField();
        c4eversiontextfield.setPreferredSize(dim_textfield1);
        c4eversiontextfield.setFont(mainpanel1.font_button);
        c4eversiontextfield.setHorizontalAlignment(2);
        c4eversiontextfield.setText("2.10.20P_SNF");
        panel6.add(c4eversiontextfield);

        c4eversiontextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                version = c4eversiontextfield.getText();
            }
        });

        c4eneulibtextfield = new JTextField();
        c4eneulibtextfield.setPreferredSize(dim_textfield1);
        c4eneulibtextfield.setFont(mainpanel1.font_button);
        c4eneulibtextfield.setHorizontalAlignment(2);
        c4eneulibtextfield.setText("/cms/CasLib/library/j20200");
        panel6.add(c4eneulibtextfield);
        c4eneulibtextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                neulib = c4eneulibtextfield.getText();
            }
        });




        JPanel panel4 = new JPanel();
        panel4.setBackground(Color.white);
//        panel4.setBackground(Color.yellow);
        panel4.setBounds(10, 365, 100, 25);
        add(panel4);

        casenr = mainpanel1.cn + 1;
        mainpanel1.case_nr.setText("case nr  " + casenr);
        mainpanel1.case_nr.setForeground(Color.black);
        mainpanel1.case_nr.setFont(mainpanel1.font_button);
        mainpanel1.case_nr.setHorizontalAlignment(0);
        mainpanel1.case_nr.setBackground(new Color(255, 255, 200));
        panel4.add(mainpanel1.case_nr);


        JPanel panel7 = new JPanel();
        panel7.setBackground(Color.white);
//        panel7.setBackground(Color.red);
        panel7.setBounds(10, 190, 100, 70);
        add(panel7);

        JLabel c4versionlabel = new JLabel("C4 version ", JLabel.LEFT);
        c4versionlabel.setPreferredSize(dim_label1);
        c4versionlabel.setForeground(Color.black);
        c4versionlabel.setFont(mainpanel1.font_button);
        c4versionlabel.setHorizontalAlignment(0);
        c4versionlabel.setBackground(new Color(255, 255, 200));
        panel7.add(c4versionlabel);

        JLabel c4neuliblabel = new JLabel("C4 neulib  ", JLabel.LEFT);
        c4neuliblabel.setPreferredSize(dim_label1);
        c4neuliblabel.setForeground(Color.black);
        c4neuliblabel.setFont(mainpanel1.font_button);
        c4neuliblabel.setHorizontalAlignment(0);
        c4neuliblabel.setBackground(new Color(255, 255, 200));
        panel7.add(c4neuliblabel);


        JPanel panel8 = new JPanel();
        panel8.setBackground(Color.white);
//        panel8.setBackground(Color.gray);
        panel8.setBounds(120, 190, 290, 70);
        add(panel8);

        c4versiontextfield = new JTextField();
        c4versiontextfield.setPreferredSize(dim_textfield1);
        c4versiontextfield.setFont(mainpanel1.font_button);
        c4versiontextfield.setHorizontalAlignment(2);
        c4versiontextfield.setText("2.05.17");
        panel8.add(c4versiontextfield);

        c4versiontextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                version = c4versiontextfield.getText();
            }
        });

        c4neulibtextfield = new JTextField();
        c4neulibtextfield.setPreferredSize(dim_textfield1);
        c4neulibtextfield.setFont(mainpanel1.font_button);
        c4neulibtextfield.setHorizontalAlignment(2);
        c4neulibtextfield.setText("/cms/CasLib/library/e4lbl70");
        panel8.add(c4neulibtextfield);
        c4neulibtextfield.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                neulib = c4neulibtextfield.getText();
            }
        });


        JPanel panel9 = new JPanel();
        panel9.setBackground(Color.white);
//        panel9.setBackground(Color.gray);
        panel9.setBounds(420, 190, 60, 30);
        add(panel9);


        c4_check = new JCheckBox("C4", false);
        c4_check.setFont(mainpanel1.font_button);
        c4_check.setPreferredSize(new Dimension(55, 25));
        c4_check.setHorizontalAlignment(2);
        panel9.add(c4_check);

        c4_check.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                if (c4_check.isSelected()) {
                    c4e_check.setSelected(false);
                    option = String.valueOf("-k");
                    version = c4versiontextfield.getText();
                    neulib = c4neulibtextfield.getText();
                } else {
                    c4e_check.setSelected(true);
                    option = String.valueOf("-ke");
                    version = c4eversiontextfield.getText();
                    neulib = c4eneulibtextfield.getText();
                }
            }
        });


        JPanel panel10 = new JPanel();
        panel10.setBackground(Color.white);
//        panel10.setBackground(Color.gray);
        panel10.setBounds(420, 100, 60, 30);
        add(panel10);


        c4e_check = new JCheckBox("C4E", true);
        c4e_check.setFont(mainpanel1.font_button);
        c4e_check.setPreferredSize(new Dimension(55, 25));
        c4e_check.setHorizontalAlignment(2);
        panel10.add(c4e_check);

        c4e_check.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                if (c4e_check.isSelected()) {
                    c4_check.setSelected(false);
                    option = String.valueOf("-ke");
                    version = c4eversiontextfield.getText();
                    neulib = c4eneulibtextfield.getText();
                } else {
                    c4_check.setSelected(true);
                    option = String.valueOf("-k");
                    version = c4versiontextfield.getText();
                    neulib = c4neulibtextfield.getText();
                }
            }
        });


    }
}
