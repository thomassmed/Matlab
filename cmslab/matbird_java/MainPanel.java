/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWArray;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.event.MouseEvent;
import java.text.DecimalFormat;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import java.awt.Dialog;
import java.awt.Dimension;
import javax.swing.JCheckBox;
import javax.swing.JTextField;
import org.openide.DialogDescriptor;
import org.openide.DialogDisplayer;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
public class MainPanel extends JPanel {

    public GrafData grafdata;
//    public MatLab[] matlabAry;
    public MatLab[] matlab;
    String str_pow[];
    String str_btf[];
    String str_btfp[];
    String str_bur[];
    String str_exp[];
    String str_rod[];
    String str_enr2[];
    String str_powp[];
    String str_tmol[];
    public JList burList;
    public JList dataList;
    public int patron_width = 370;
//    static int patron_width = 370;
//    int ypatron_offset = 220;
    int ypatron_offset = 130;
    int xpatron_offset = 120;
    int xenr_offset = xpatron_offset + patron_width + 20;
    int cell;
    int cell_enr = 37;
    int cell_add = 20;
    public int ch = 5;
//    static double rod_scale = 0.7;
    public double rod_scale = 0.7;
    Graphics g;
    public int witdh;
//    static int witdh;
    public JSlider burnupslider;
    DecimalFormat df2 = new DecimalFormat("0.00");
    DecimalFormat df3 = new DecimalFormat("0.000");
    DecimalFormat df0 = new DecimalFormat("#");
    public boolean enrpushed = true;
    public boolean tmolpushed = false;
    public boolean powpushed = false;
    public boolean btfpushed = false;
    public boolean btfppushed = false;
    public boolean powppushed = false;
    public boolean exppushed = false;
    public boolean rodpushed = false;
    public boolean datalistpushed = false;
    public boolean plusenrpushed = false;
    public boolean minusenrpushed = false;
    private javax.swing.JButton enr;
    private javax.swing.JButton pow;
    private javax.swing.JButton btf;
    private javax.swing.JButton btfp;
    private javax.swing.JButton powp;
    private javax.swing.JButton tmol;
    private javax.swing.JButton exp;
    private javax.swing.JButton rod;
    public JLabel point_message;
    public JLabel caifile_message;
    public JLabel u235_message;
    public int x_pos;
    public int y_pos;
    public int x_enrpos;
    public int y_enrpos;
    int index;
    public LogoPanel logopanel;
    public int x_size = 800;
    public int y_size = 700;
//    static int x_size = 800;
//    static int y_size = 700;
    public int cn;
    public JSlider caseslider;
    private javax.swing.JButton plusenr;
    private javax.swing.JButton minusenr;
    Object[] matvec;
    Object[] matvec1;
    int cnmax;
    public JLabel bur_message;
    public JLabel data_message;
    Font font_labels = new Font("LucidaTypewriterBold", Font.BOLD, 12);
    Font font_button = new Font("Times New Roman", Font.BOLD, 13);
    public int axial_window_height = 600;
    public JCheckBox[] ax_check;
    JCheckBox axial_btf_check;
    JCheckBox fkinf_check;
    JCheckBox crd_check;
    String btf_str;
    String fint_str;
    String u235_str;
    public JPanel casmopanel;
//    public JPanel plotpanel;
    JTextField caifiletextfield;
    JTextField caxfiletextfield;
    JLabel case_nr;
    int casenr;
    Dimension dim = new Dimension(57, 30);
    Dimension dim1 = new Dimension(80, 30);
    int top_nr;
    static int[] opt_top_comp;

    public boolean fuel_panel_open = false;

    public MainPanel(String[] caxfiles, int nr, MatLab matlabx) {

        setBackground(new Color(220, 200, 180));
        setBackground(Color.white);

        cn = 0;
        cnmax = caxfiles.length - 1;
        ax_check = new JCheckBox[cnmax + 1];
        for (int i = 0; i <= cnmax; i++) {
            ax_check[i] = new JCheckBox("Axial Change", true);
        }

        matlab = new MatLab[6];
        opt_top_comp = new int[6];

        for (int i = 0; i < 6; i++) {
            opt_top_comp[i] = 0;
        }

        top_nr = nr;
        matlab[top_nr] = matlabx;

        grafdata = new GrafData();
        setLayout(null);

        caifiletextfield = new JTextField();
        caxfiletextfield = new JTextField();
        case_nr = new JLabel("case nr", JLabel.CENTER);

        cell = (patron_width / matlab[top_nr].npst);

        str_pow = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_btf = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_btfp = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_exp = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_rod = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_bur = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_enr2 = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_powp = new String[matlab[top_nr].npst*matlab[top_nr].npst];
        str_tmol = new String[matlab[top_nr].npst*matlab[top_nr].npst];

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_pow[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].pow[cn][i][j][0]);
            }
        }
        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_btf[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].btf[cn][i][j][0]);
            }
        }
        for (int i = 0; i < matlab[top_nr].burnup[cn].length; i++) {
            str_bur[i] = Double.toString(matlab[top_nr].burnup[cn][i]);
//            str_bur[i] = df2.format(matlab[top_nr].burnup[i]);
        }

        burList = new JList(str_bur);
        JScrollPane burscrollPane = new JScrollPane(burList);
        burList.setBackground(new Color(255, 255, 210));
        burscrollPane.setBounds(10, 0, 70, (int) 0.7 * witdh);
        burscrollPane.setBounds(10, ypatron_offset, 70, patron_width);
        burList.addMouseListener(new java.awt.event.MouseAdapter() {

            @Override
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                burlistMouseClicked(evt);

            }

            private void burlistMouseClicked(MouseEvent evt) {
                if (evt.getClickCount() == 1) {
                    int indx = burList.getSelectedIndex();
                    System.out.println("Burnup point nr " + indx);
                    burnupslider.setValue(indx);
//                    System.out.println(burnupslider.getValue());
//                    burList.setSelectedIndex(burnupslider.getValue());


                    fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                    if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                        btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                    } else if (axial_btf_check.isSelected()) {
                        btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                    } else {
                        btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                    }

                    point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                            + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                            + "   fint = " + fint_str
                            + btf_str);


                    repaint();
                }
            }
        });
        burList.setFont(font_labels);
        add(burscrollPane);

        dataList = new JList(str_pow);
        JScrollPane datascrollPane = new JScrollPane(dataList);
        datascrollPane.setBounds(700, ypatron_offset, 70, patron_width);

        dataList.addMouseListener(new java.awt.event.MouseAdapter() {

            @Override
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                datalistMouseClicked(evt);

            }

            private void datalistMouseClicked(MouseEvent evt) {
                if (evt.getClickCount() == 1) {
                    index = dataList.getSelectedIndex();
                    dataList.setSelectedIndex(index);
                    datalistpushed = true;
                    repaint();
                }
            }
        });

        dataList.setBackground(new Color(255, 255, 210));
        dataList.setFont(font_labels);
        add(datascrollPane);


        burnupslider = new javax.swing.JSlider(0, matlab[top_nr].burnup[cn].length - 1, 0);
        burnupslider.addMouseListener(new java.awt.event.MouseAdapter() {

            @Override
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                burnupsliderMouseClicked(evt);

            }

            private void burnupsliderMouseClicked(MouseEvent evt) {
                if (evt.getClickCount() == 1) {
                    System.out.println(burnupslider.getValue());
                    burList.setSelectedIndex(burnupslider.getValue());
                    burList.ensureIndexIsVisible(burnupslider.getValue());
                    fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                    if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                        btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                    } else if (axial_btf_check.isSelected()) {
                        btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                    } else {
                        btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                    }

                    point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                            + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                            + "   fint = " + fint_str
                            + btf_str);

                    repaint();
                }
            }
        });
//
//        burnupslider.addChangeListener(new javax.swing.event.ChangeListener() {
//
//            @Override
//            public void stateChanged(javax.swing.event.ChangeEvent evt) {
//                burnupsliderstateChanged(evt);
//            }
//
//            private void burnupsliderstateChanged(ChangeEvent evt) {
//                burList.setSelectedIndex(burnupslider.getValue());
//                burList.ensureIndexIsVisible(burnupslider.getValue());
//
//                fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
//                if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
//                    btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
//                } else if (axial_btf_check.isSelected()) {
//                    btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
//                } else {
//                    btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
//                }
//
//                point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
//                        + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
//                        + "   fint = " + fint_str
//                        + btf_str);
//            }
//        });

        burnupslider.setBounds(10, 405 + ypatron_offset, 70, 35);
        burnupslider.setBackground(new Color(255, 255, 200));
        burnupslider.setFont(font_labels);
        add(burnupslider);


        final SpinnerNumberModel model = new SpinnerNumberModel(cn + 1, 1, caxfiles.length, 1);
        JSpinner casespinner = new JSpinner(model);
        model.addChangeListener(new ChangeListener() {

            @Override
            public void stateChanged(ChangeEvent e) {
                Number nr = model.getNumber();
                cn = nr.intValue() - 1;

//                if (axial_btf_check.isSelected()) {
//                    u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
//                } else {
//                    u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
//                }
//                u235_message.setText(u235_str);

                caifiletextfield.setText(matlab[top_nr].caifile[cn]);
                caxfiletextfield.setText(matlab[top_nr].caxfile[cn]);
                casenr = cn + 1;
                case_nr.setText("case nr  " + casenr);

                caifile_message.setText("Casmo input file:   " + matlab[top_nr].caifile[cn] +",  "+ matlab[top_nr].sim[cn]);

                fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                    btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                } else if (axial_btf_check.isSelected()) {
                    btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                } else {
                    btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                }

                point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                        + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                        + "   fint = " + fint_str
                        + btf_str);

                if (axial_btf_check.isSelected()) {
                    u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
                } else {
                    u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
                }
                u235_message.setText(u235_str);


//                update();
                repaint();
            }
        });
        casespinner.setBounds(720, 405 + ypatron_offset, 45, 30);
        Font font_spinner = new Font("Times New Roman", Font.BOLD, 14);
        casespinner.setFont(font_spinner);
        add(casespinner);


        point_message = new JLabel("Burnup", JLabel.RIGHT);
        point_message.setForeground(Color.black);
        point_message.setHorizontalAlignment(2);
        point_message.setBounds(100, 420 + ypatron_offset, 500, 20);
        point_message.setBackground(new Color(255, 255, 200));

        btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
        fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);

        point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                + "   fint = " + fint_str
                + btf_str);

        point_message.setFont(font_labels);
        add(point_message);

        bur_message = new JLabel("Burnup", JLabel.CENTER);
        bur_message.setForeground(Color.black);
        bur_message.setHorizontalAlignment(2);
        bur_message.setBounds(10, ypatron_offset - 30, 90, 20);
        bur_message.setFont(font_labels);
        add(bur_message);

        data_message = new JLabel("POW", JLabel.CENTER);
        data_message.setForeground(Color.black);
        data_message.setHorizontalAlignment(2);
        data_message.setBounds(700, ypatron_offset - 30, 150, 20);
        data_message.setFont(font_labels);
        add(data_message);


        u235_message = new JLabel("U235", JLabel.CENTER);
        u235_message.setForeground(Color.black);
        u235_message.setHorizontalAlignment(2);
        u235_message.setBounds(580, 420 + ypatron_offset, 120, 20);
        u235_message.setBackground(new Color(255, 255, 200));
//        u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
        u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
        u235_message.setText(u235_str);
        u235_message.setFont(font_labels);
        add(u235_message);

        caifile_message = new JLabel("U235", JLabel.LEFT);
        caifile_message.setForeground(Color.black);
        caifile_message.setBounds(100, 381 + ypatron_offset, 700, 20);
        caifile_message.setText("Casmo input file:   "+matlab[top_nr].caifile[cn]+",  "+ matlab[top_nr].sim[cn]);
        caifile_message.setFont(font_labels);
        add(caifile_message);



        JPanel buttonPanel1 = new JPanel();
        buttonPanel1.setBackground(Color.white);
//        buttonPanel1.setBackground(Color.yellow);
        buttonPanel1.setBounds(10, 10, 250, 80);
        add(buttonPanel1);

        enr = new javax.swing.JButton("ENR");
        enr.setPreferredSize(dim);
        enr.setFont(font_button);
        buttonPanel1.add(enr);
        enr.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                enrpushed = true;
                rodpushed = false;
                powpushed = false;
                tmolpushed = false;
                powppushed = false;
                btfpushed = false;
                datalistpushed = false;
                plusenrpushed = false;
                minusenrpushed = false;
                btfppushed = false;
//                data_message.setText("ENR");
                if (axial_btf_check.isSelected()) {
                    u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
                } else {
                    u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
                }
                u235_message.setText(u235_str);
                repaint();
            }
        });

        pow = new javax.swing.JButton("POW");
        pow.setPreferredSize(dim);
        pow.setFont(font_button);
        buttonPanel1.add(pow);
        pow.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                powpushed = true;
                rodpushed = false;
                powppushed = false;
                tmolpushed = false;
                enrpushed = false;
                exppushed = false;
                btfpushed = false;
                datalistpushed = false;
                plusenrpushed = false;
                minusenrpushed = false;
                btfppushed = false;
                data_message.setText("POW");

                fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                    btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                } else if (axial_btf_check.isSelected()) {
                    btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                } else {
                    btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                }

                point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                        + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                        + "   fint = " + fint_str
                        + btf_str);

                if (axial_btf_check.isSelected()) {
                    u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
                } else {
                    u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
                }
                u235_message.setText(u235_str);

                repaint();
            }
        });
        btf = new javax.swing.JButton("BTF");
        btf.setPreferredSize(dim);
        btf.setFont(font_button);
        buttonPanel1.add(btf);
        btf.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }
                if (safe == 1) {
                    btfpushed = true;
                    rodpushed = false;
                    powpushed = false;
                    powppushed = false;
                    enrpushed = false;
                    exppushed = false;
                    datalistpushed = false;
                    plusenrpushed = false;
                    minusenrpushed = false;
                    btfppushed = false;
                    if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                        data_message.setText("<BTF(kinf)>");
                    } else if (axial_btf_check.isSelected()) {
                        data_message.setText("<BTF>");
                    } else {
                        data_message.setText("BTF");
                    }
                    update();
                }
            }
        });


        btfp = new javax.swing.JButton("BTFP");
        btfp.setPreferredSize(dim);
        btfp.setFont(font_button);
        buttonPanel1.add(btfp);
        btfp.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                data_message.setText("BTFP");
                btfppushed = true;
                rodpushed = false;
                powpushed = false;
                tmolpushed = false;
                btfpushed = false;
                powpushed = false;
                enrpushed = false;
                exppushed = false;
                datalistpushed = false;
                plusenrpushed = false;
                minusenrpushed = false;
                repaint();
            }
        });

        powp = new javax.swing.JButton("POWP");
        powp.setPreferredSize(dim);
        powp.setFont(font_button);
        buttonPanel1.add(powp);
        powp.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                data_message.setText("POWP");
                powppushed = true;
                rodpushed = false;
                btfppushed = false;
                btfpushed = false;
                powpushed = false;
                tmolpushed = false;
                enrpushed = false;
                exppushed = false;
                datalistpushed = false;
                plusenrpushed = false;
                minusenrpushed = false;
                update();
                repaint();
            }
        });


        tmol = new javax.swing.JButton("TMOL");
        tmol.setPreferredSize(dim);
        tmol.setFont(font_button);
        buttonPanel1.add(tmol);
        tmol.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                data_message.setText("TMOL");
                tmolpushed = true;
                rodpushed = false;
                btfppushed = false;
                btfpushed = false;
                powpushed = false;
                powppushed = false;
                enrpushed = false;
                exppushed = false;
                datalistpushed = false;
                plusenrpushed = false;
                minusenrpushed = false;
                repaint();
            }
        });


        exp = new javax.swing.JButton("EXP");
        exp.setPreferredSize(dim);
        exp.setFont(font_button);
        buttonPanel1.add(exp);
        exp.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }
                if (safe == 1) {
                    data_message.setText("EXP");
                    exppushed = true;
                    rodpushed = false;
                    powpushed = false;
                    btfppushed = false;
                    btfpushed = false;
                    powpushed = false;
                    tmolpushed = false;
                    enrpushed = false;
                    datalistpushed = false;
                    plusenrpushed = false;
                    minusenrpushed = false;
                    repaint();
                }
            }
        });

        rod = new javax.swing.JButton("ROD");
        rod.setPreferredSize(dim);
        rod.setFont(font_button);
        buttonPanel1.add(rod);
        rod.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }
                if (safe == 1) {
                    data_message.setText("ROD");
                    rodpushed = true;
                    exppushed = false;
                    powppushed = false;
                    tmolpushed = false;
                    btfppushed = false;
                    btfpushed = false;
                    powpushed = false;
                    enrpushed = false;
                    datalistpushed = false;
                    plusenrpushed = false;
                    minusenrpushed = false;
                    repaint();
                }
            }
        });




        JPanel buttonPanel2 = new JPanel();
        buttonPanel2.setBackground(Color.white);
//        buttonPanel2.setBackground(Color.green);
        buttonPanel2.setBounds(270, 10, 120, 80);
        add(buttonPanel2);

        plusenr = new javax.swing.JButton("+ ENR");
        plusenr.setFont(font_button);
        buttonPanel2.add(plusenr);
        plusenr.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }
                if (safe == 1) {

                    if (x_pos >= 0 && x_pos <= matlab[top_nr].npst && y_pos >= 0 && y_pos <= matlab[top_nr].npst) {
                        try {
                            plusenrpushed = true;

                            for (int i = 0; i <= cnmax; i++) {
                                if (ax_check[i].isSelected()) {
                                    matvec1 = matlab[top_nr].matte.java_increase_enr(1, i + 1, x_pos + 1, y_pos + 1);
                                    MWNumericArray mlfu = (MWNumericArray) matvec1[0];
                                    matlab[top_nr].lfu[i] = (int[][]) mlfu.toIntArray();
                                    MWArray.disposeArray(mlfu);
//                                    matlab[top_nr].matDispose(matvec1);

                                    if (btfpushed == true || powpushed == true) {
                                        matlab[top_nr].matte.java_bigcalc(i + 1);
                                        matlab[top_nr].matte.java_calcbtf(i + 1);
                                    }

                                    matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                                    MWNumericArray mpow = (MWNumericArray) matvec[2];
                                    matlab[top_nr].pow[i] = (double[][][]) mpow.toDoubleArray();
                                    MWArray.disposeArray(mpow);
                                    MWNumericArray mbtf = (MWNumericArray) matvec[5];
                                    matlab[top_nr].btf[i] = (double[][][]) mbtf.toDoubleArray();
                                    MWArray.disposeArray(mbtf);
                                    MWNumericArray mba = (MWNumericArray) matvec[19];
                                    matlab[top_nr].ba[i] = (double[][]) mba.toDoubleArray();
                                    MWArray.disposeArray(mba);
                                    MWNumericArray mu235 = (MWNumericArray) matvec[10];
                                    matlab[top_nr].u235[i] = mu235.getDouble();
                                    MWArray.disposeArray(mu235);
                                }
                            }
                            if (btfpushed == true || powpushed == true) {
                                matvec1 = matlab[top_nr].matte.java_calcbtfax(1);
                                matvec1 = matlab[top_nr].matte.java_calcbtfaxenv(3);
                            }
                            matvec1 = matlab[top_nr].matte.java_calc_mean_u235(1);
                            MWNumericArray mmean_u235 = (MWNumericArray) matvec1[0];
                            matlab[top_nr].mean_u235 = mmean_u235.getDouble();
                            MWArray.disposeArray(mmean_u235);

                            for (int i = 0; i <= cnmax; i++) {
                                matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                                MWNumericArray mbtfax = (MWNumericArray) matvec[11];
                                matlab[top_nr].btfax[i] = (double[][][]) mbtfax.toDoubleArray();
                                MWArray.disposeArray(mbtfax);
                                MWNumericArray mbtfax_env = (MWNumericArray) matvec[12];
                                matlab[top_nr].btfax_env[i] = (double[][]) mbtfax_env.toDoubleArray();
                                MWArray.disposeArray(mbtfax_env);
                                MWNumericArray mfint = (MWNumericArray) matvec[13];
                                matlab[top_nr].fint[i] = mfint.getDoubleData();
                                MWArray.disposeArray(mfint);
                                MWNumericArray mmaxbtf = (MWNumericArray) matvec[14];
                                matlab[top_nr].maxbtf[i] = mmaxbtf.getDoubleData();
                                MWArray.disposeArray(mmaxbtf);
                                MWNumericArray mmaxbtfax = (MWNumericArray) matvec[15];
                                matlab[top_nr].maxbtfax[i] = mmaxbtfax.getDoubleData();
                                MWArray.disposeArray(mmaxbtfax);
                                MWNumericArray mmaxbtfax_env = (MWNumericArray) matvec[16];
                                matlab[top_nr].maxbtfax_env[i] = mmaxbtfax_env.getDouble();
                                MWArray.disposeArray(mmaxbtfax_env);
                            }

                            fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                            if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                                btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                            } else if (axial_btf_check.isSelected()) {
                                btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                            } else {
                                btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                            }

                            point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                                    + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                                    + "   fint = " + fint_str
                                    + btf_str);

                            if (axial_btf_check.isSelected()) {
                                u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
                            } else {
                                u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
                            }
                            u235_message.setText(u235_str);

                            repaint();
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
            }
        });
        minusenr = new javax.swing.JButton("- ENR");
        minusenr.setFont(font_button);
        buttonPanel2.add(minusenr);
        minusenr.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {

                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }

                if (safe == 1) {
                    if (x_pos >= 0 && x_pos <= matlab[top_nr].npst && y_pos >= 0 && y_pos <= matlab[top_nr].npst) {
                        try {
                            minusenrpushed = true;

                            for (int i = 0; i <= cnmax; i++) {
                                if (ax_check[i].isSelected()) {
                                    matvec1 = matlab[top_nr].matte.java_decrease_enr(1, i + 1, x_pos + 1, y_pos + 1);
                                    MWNumericArray mlfu = (MWNumericArray) matvec1[0];
                                    matlab[top_nr].lfu[i] = (int[][]) mlfu.toIntArray();
                                    MWArray.disposeArray(mlfu);
                                    if (btfpushed == true || powpushed == true) {
                                        matlab[top_nr].matte.java_bigcalc(i + 1);
                                        matlab[top_nr].matte.java_calcbtf(i + 1);
                                    }

                                    matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                                    MWNumericArray mpow = (MWNumericArray) matvec[2];
                                    matlab[top_nr].pow[i] = (double[][][]) mpow.toDoubleArray();
                                    MWArray.disposeArray(mpow);
                                    MWNumericArray mbtf = (MWNumericArray) matvec[5];
                                    matlab[top_nr].btf[i] = (double[][][]) mbtf.toDoubleArray();
                                    MWArray.disposeArray(mbtf);
                                    MWNumericArray mba = (MWNumericArray) matvec[19];
                                    matlab[top_nr].ba[i] = (double[][]) mba.toDoubleArray();
                                    MWArray.disposeArray(mba);
                                    MWNumericArray mu235 = (MWNumericArray) matvec[10];
                                    matlab[top_nr].u235[i] = mu235.getDouble();
                                    MWArray.disposeArray(mu235);
                                }
                            }
                            if (btfpushed == true || powpushed == true) {
                                matvec1 = matlab[top_nr].matte.java_calcbtfax(1);
                                matvec1 = matlab[top_nr].matte.java_calcbtfaxenv(3);
                            }
                            matvec1 = matlab[top_nr].matte.java_calc_mean_u235(1);
                            MWNumericArray mmean_u235 = (MWNumericArray) matvec1[0];
                            matlab[top_nr].mean_u235 = mmean_u235.getDouble();
                            MWArray.disposeArray(mmean_u235);
//                        matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, cn + 1);
                            for (int i = 0; i <= cnmax; i++) {
                                matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                                MWNumericArray mbtfax = (MWNumericArray) matvec[11];
                                matlab[top_nr].btfax[i] = (double[][][]) mbtfax.toDoubleArray();
                                MWArray.disposeArray(mbtfax);
                                MWNumericArray mbtfax_env = (MWNumericArray) matvec[12];
                                matlab[top_nr].btfax_env[i] = (double[][]) mbtfax_env.toDoubleArray();
                                MWArray.disposeArray(mbtfax_env);
                                MWNumericArray mfint = (MWNumericArray) matvec[13];
                                matlab[top_nr].fint[i] = mfint.getDoubleData();
                                MWArray.disposeArray(mfint);
                                MWNumericArray mmaxbtf = (MWNumericArray) matvec[14];
                                matlab[top_nr].maxbtf[i] = mmaxbtf.getDoubleData();
                                MWArray.disposeArray(mmaxbtf);
                                MWNumericArray mmaxbtfax = (MWNumericArray) matvec[15];
                                matlab[top_nr].maxbtfax[i] = mmaxbtfax.getDoubleData();
                                MWArray.disposeArray(mmaxbtfax);
                                MWNumericArray mmaxbtfax_env = (MWNumericArray) matvec[16];
                                matlab[top_nr].maxbtfax_env[i] = mmaxbtfax_env.getDouble();
                                MWArray.disposeArray(mmaxbtfax_env);
                            }

                            fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
                            if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
                                btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
                            } else if (axial_btf_check.isSelected()) {
                                btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
                            } else {
                                btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
                            }

                            point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                                    + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                                    + "   fint = " + fint_str
                                    + btf_str);

                            if (axial_btf_check.isSelected()) {
                                u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
                            } else {
                                u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
                            }
                            u235_message.setText(u235_str);

                            repaint();
                        } catch (MWException ex) {
                            Exceptions.printStackTrace(ex);
                        }
                    }
                }
            }
        });

        javax.swing.JButton bigcalc = new javax.swing.JButton("Pertubation");
        bigcalc.setFont(font_button);
        buttonPanel2.add(bigcalc);

        bigcalc.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                int crashrisk = 0;
                int ok = 0;
                int safe = 0;
                for (int i = 1; i < 6; i++) {
                    if (opt_top_comp[i] == i) {
                        crashrisk = 1;
                        ok = i;
                    }
                }
                if (crashrisk == 1) {
                    if (top_nr == ok) {
                        safe = 1;
                    }
                } else {
                    safe = 1;
                }

                if (safe == 1) {
                    update();
                    repaint();
                }
            }
        });


        JPanel buttonPanel3 = new JPanel();
        buttonPanel3.setBackground(Color.white);
//        buttonPanel3.setBackground(Color.green);
//        buttonPanel3.setBounds(140, 135, 180, 45);
        buttonPanel3.setBounds(400, 10, 180, 45);
        add(buttonPanel3);

        javax.swing.JButton axial = new javax.swing.JButton("Axial ...");
        axial.setFont(font_button);
        buttonPanel3.add(axial);

        axial.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintAxial(g);
            }
        });

        javax.swing.JButton optimize = new javax.swing.JButton("Optimize ...");
        optimize.setFont(font_button);
        buttonPanel3.add(optimize);

        optimize.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintOptimize(g);


            }
        });

        JPanel buttonPanel4 = new JPanel();
        buttonPanel4.setBackground(Color.white);
//        buttonPanel4.setBackground(Color.pink);
//        buttonPanel4.setBounds(400, 60, 180, 30);
        buttonPanel4.setBounds(370, 60, 270, 30);
        add(buttonPanel4);

        axial_btf_check = new JCheckBox("Axial BTF", false);
        axial_btf_check.setFont(new Font("Times New Roman", Font.BOLD, 13));
        buttonPanel4.add(axial_btf_check);

        fkinf_check = new JCheckBox("f(kinf)", true);
        fkinf_check.setFont(new Font("Times New Roman", Font.BOLD, 13));
        buttonPanel4.add(fkinf_check);

        crd_check = new JCheckBox("CRD", false);
        crd_check.setFont(new Font("Times New Roman", Font.BOLD, 13));
        buttonPanel4.add(crd_check);

        crd_check.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                repaint();
            }
        });

        JPanel buttonPanel5 = new JPanel();
        buttonPanel5.setBackground(Color.white);
//        buttonPanel5.setBackground(Color.green);
//        buttonPanel5.setBounds(590, 10, 180, 80);
        buttonPanel5.setBounds(650, 10, 180, 80);
        add(buttonPanel5);

        javax.swing.JButton casmo = new javax.swing.JButton("Casmo ...");
        casmo.setFont(font_button);
        casmo.setPreferredSize(dim1);
        buttonPanel5.add(casmo);
        casmo.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintCasmo(g);
            }
        });

        javax.swing.JButton plot = new javax.swing.JButton("Plot ...");
        plot.setFont(font_button);
        plot.setPreferredSize(dim1);
        buttonPanel5.add(plot);
        plot.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintPlot(g);
            }
        });


        javax.swing.JButton channelbow = new javax.swing.JButton("Bowing");
        channelbow.setFont(font_button);
        channelbow.setPreferredSize(dim1);
        buttonPanel5.add(channelbow);
        channelbow.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintBowing(g);
            }
        });


        javax.swing.JButton fuel_data = new javax.swing.JButton("Data ...");
        fuel_data.setFont(font_button);
        fuel_data.setPreferredSize(dim1);
        buttonPanel5.add(fuel_data);
        fuel_data.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                paintData(g);
            }
        });



    }

    public void paintPatron(Graphics g) {

        Font font;
        int a;
        int b;

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                g.setColor(Color.white);
                g.fillRect(xpatron_offset + ch + j * cell, ch + ypatron_offset + i * cell, cell, cell);
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                }
            }
        }
        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].lfu[cn][i][j] > 9) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].lfu[cn][i][j] > 9) {
                            a = -5;
                            b = 0;
                        } else {
                            a = -1;
                            b = 0;
                        }
                    } else {
                        if (matlab[top_nr].lfu[cn][i][j] > 9) {
                            a = -4;
                            b = -1;
                        } else {
                            a = 0;
                            b = -1;
                        }
                    }
                    if (matlab[top_nr].ba[cn][i][j] > 0) {
                        if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                            a = -1;
                            b = -1;
                        } else {
                            a = 0;
                            b = -1;
                        }
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
                        g.setFont(font);
                        g.drawString("BA",
                                xpatron_offset + ch + (int) (0.35 * cell + j * cell + a - 3),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    } else {
                        g.drawString(Integer.toString(matlab[top_nr].lfu[cn][i][j]),
                                xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    }
                }
            }
        }
    }

    public void paintPow(Graphics g) {


        Font font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
        int col = 0;
        int a;
        int b;

        double[][] dist;
        dist = new double[matlab[top_nr].npst][matlab[top_nr].npst];


        if (crd_check.isSelected()) {
            for (int i = 0; i < matlab[top_nr].npst; i++) {
                for (int j = 0; j < matlab[top_nr].npst; j++) {
                    dist[i][j] = matlab[top_nr].pow_crd[cn][i][j][burnupslider.getValue()];
                }
            }
        } else {
            for (int i = 0; i < matlab[top_nr].npst; i++) {
                for (int j = 0; j < matlab[top_nr].npst; j++) {
                    dist[i][j] = matlab[top_nr].pow[cn][i][j][burnupslider.getValue()];
                }
            }
        }


        g.setFont(font);

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.white);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }







        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (dist[i][j] > 1.30) {
                        col = 8;
                    } else if (dist[i][j] > 1.25) {
                        col = 7;
                    } else if (dist[i][j] > 1.2) {
                        col = 6;
                    } else if (dist[i][j] > 1.1) {
                        col = 5;
                    } else if (dist[i][j] > 1.0) {
                        col = 4;
                    } else if (dist[i][j] > 0.9) {
                        col = 3;
                    } else if (dist[i][j] > 0.8) {
                        col = 2;
                    } else {
                        col = 1;
                    }
                    g.setColor(grafdata.color[col]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                }
            }
        }


        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (dist[i][j] > 1.095) {
                            a = -1;
                            b = 0;
                        } else {
                            a = +1;
                            b = 0;
                        }
                    } else {
                        if (dist[i][j] > 1.095) {
                            a = 1;
                            b = -1;
                        } else {
                            a = 2;
                            b = -1;
                        }
                    }

                    if (dist[i][j] > 1.095) {
                        g.drawString(Integer.toString((int) Math.round((100 * (dist[i][j] - 1)))),
                                xpatron_offset + (int) (0.5 * ch + (int) (0.35 * cell + j * cell + a)),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    } else if (dist[i][j] > 1.0) {
                        g.drawString(Integer.toString((int) Math.round((100 * (dist[i][j] - 1)))),
                                xpatron_offset + (int) (1.0 * ch + (int) (0.35 * cell + j * cell) + a),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell) + b);
                    }
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_pow[i + matlab[top_nr].npst * j] = df3.format(dist[i][j]);
            }
        }



//        for (int i = 0; i < matlab[top_nr].npst; i++) {
//            for (int j = 0; j < matlab[top_nr].npst; j++) {
//                if (matlab[top_nr].lfu[cn][i][j] > 0) {
//                    if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.30) {
//                        col = 8;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.25) {
//                        col = 7;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.2) {
//                        col = 6;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.1) {
//                        col = 5;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.0) {
//                        col = 4;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 0.9) {
//                        col = 3;
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 0.8) {
//                        col = 2;
//                    } else {
//                        col = 1;
//                    }
//                    g.setColor(grafdata.color[col]);
//                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
//                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
//                            (int) (rod_scale * cell),
//                            (int) (rod_scale * cell));
//                    g.setColor(Color.black);
//                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
//                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
//                            (int) (rod_scale * cell),
//                            (int) (rod_scale * cell));
//                }
//            }
//        }

//        for (int i = 0; i < matlab[top_nr].npst; i++) {
//            for (int j = 0; j < matlab[top_nr].npst; j++) {
//                if (matlab[top_nr].lfu[cn][i][j] > 0) {
//                    g.setColor(Color.black);
//                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
//                        if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.095) {
//                            a = -1;
//                            b = 0;
//                        } else {
//                            a = +1;
//                            b = 0;
//                        }
//                    } else {
//                        if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.095) {
//                            a = 1;
//                            b = -1;
//                        } else {
//                            a = 2;
//                            b = -1;
//                        }
//                    }
//
//                    if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.095) {
//                        g.drawString(Integer.toString((int) Math.round((100 * (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] - 1)))),
//                                xpatron_offset + (int) (0.5 * ch + (int) (0.35 * cell + j * cell + a)),
//                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
//                    } else if (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] > 1.0) {
//                        g.drawString(Integer.toString((int) Math.round((100 * (matlab[top_nr].pow[cn][i][j][burnupslider.getValue()] - 1)))),
//                                xpatron_offset + (int) (1.0 * ch + (int) (0.35 * cell + j * cell) + a),
//                                ypatron_offset + ch + (int) (0.65 * cell + i * cell) + b);
//                    }
//                }
//            }
//        }
//
//        for (int i = 0; i < matlab[top_nr].npst; i++) {
//            for (int j = 0; j < matlab[top_nr].npst; j++) {
//                str_pow[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].pow[cn][i][j][burnupslider.getValue()]);
//            }
//        }
    }




    public void paintBTF(Graphics g) {
        Font font = new Font("Times New Roman", Font.BOLD, 16);
        //  Font font = new Font("Monospaced", Font.BOLD, 16);
        int col = 0;
        Double max = 0.0;
        Double min = 10.0;
        Double diff;
        g.setFont(font);
        int a;
        int b;

        if (axial_btf_check.isSelected()) {
            if (fkinf_check.isSelected()) {

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        if (matlab[top_nr].lfu[cn][i][j] > 0) {
                            if (matlab[top_nr].btfax_env[cn][i][j] > max) {
                                max = matlab[top_nr].btfax_env[cn][i][j];
                            }
//                            if (matlab[top_nr].btfax_env[cn][i][j] < min) {
//                                min = matlab[top_nr].btfax_env[cn][i][j];
//                            }
                        }
                    }
                }

//                diff = max - min;

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        if (matlab[top_nr].lfu[cn][i][j] > 0) {

                        if (matlab[top_nr].btfax_env[cn][i][j] > 0.997*max) {
                            col = 8;
                        } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.995*max) {
                            col = 7;
                            } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.99 * max) {
                                col = 6;
                            } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.98 * max) {
                                col = 5;
                            } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.96 * max) {
                                col = 4;
                            } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.94 * max) {
                                col = 3;
                            } else if (matlab[top_nr].btfax_env[cn][i][j] > 0.92 * max) {
                                col = 2;
                            } else {
                                col = 1;
                            }
                            g.setColor(grafdata.color[col]);
                            g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                            g.setColor(Color.black);
                            g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                        }
                    }
                }

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        str_btf[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].btfax_env[cn][i][j]);
                    }
                }

            } else {

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        if (matlab[top_nr].lfu[cn][i][j] > 0) {
                            if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max) {
                                max = matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()];
                            }
                            if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] < min) {
                                min = matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()];
                            }
                        }
                    }
                }

                diff = max - min;

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        if (matlab[top_nr].lfu[cn][i][j] > 0) {
                            if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - diff / 8) {
                                col = 8;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 2 * diff / 8) {
                                col = 7;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 3 * diff / 8) {
                                col = 6;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 4 * diff / 8) {
                                col = 5;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 5 * diff / 8) {
                                col = 4;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 6 * diff / 8) {
                                col = 3;
                            } else if (matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()] > max - 7 * diff / 8) {
                                col = 2;
                            } else {
                                col = 1;
                            }
                            g.setColor(grafdata.color[col]);
                            g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                            g.setColor(Color.black);
                            g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                        }
                    }
                }

                for (int i = 0; i < matlab[top_nr].npst; i++) {
                    for (int j = 0; j < matlab[top_nr].npst; j++) {
                        str_btf[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].btfax[cn][i][j][burnupslider.getValue()]);
                    }
                }
            }
        } else {

            for (int i = 0; i < matlab[top_nr].npst; i++) {
                for (int j = 0; j < matlab[top_nr].npst; j++) {
                    if (matlab[top_nr].lfu[cn][i][j] > 0) {
                        if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max) {
                            max = matlab[top_nr].btf[cn][i][j][burnupslider.getValue()];
                        }
                        if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] < min) {
                            min = matlab[top_nr].btf[cn][i][j][burnupslider.getValue()];
                        }
                    }
                }
            }

            diff = max - min;

            for (int i = 0; i < matlab[top_nr].npst; i++) {
                for (int j = 0; j < matlab[top_nr].npst; j++) {
                    if (matlab[top_nr].lfu[cn][i][j] > 0) {
                        if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - diff / 8) {
                            col = 8;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 2 * diff / 8) {
                            col = 7;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 3 * diff / 8) {
                            col = 6;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 4 * diff / 8) {
                            col = 5;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 5 * diff / 8) {
                            col = 4;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 6 * diff / 8) {
                            col = 3;
                        } else if (matlab[top_nr].btf[cn][i][j][burnupslider.getValue()] > max - 7 * diff / 8) {
                            col = 2;
                        } else {
                            col = 1;
                        }
                        g.setColor(grafdata.color[col]);
                        g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                        g.setColor(Color.black);
                        g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                    }
                }
            }

            for (int i = 0; i < matlab[top_nr].npst; i++) {
                for (int j = 0; j < matlab[top_nr].npst; j++) {
                    str_btf[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].btf[cn][i][j][burnupslider.getValue()]);
                }
            }
        }


        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                }
            }
        }


        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].lfu[cn][i][j] > 9) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].lfu[cn][i][j] > 9) {
                            a = -5;
                            b = 0;
                        } else {
                            a = -1;
                            b = 1;
                        }
                    } else {
                        if (matlab[top_nr].lfu[cn][i][j] > 9) {
                            a = -4;
                            b = -1;
                        } else {
                            a = 0;
                            b = -1;
                        }
                    }


                    if (matlab[top_nr].ba[cn][i][j] > 0) {
                        if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                            a = -1;
                            b = -1;
                        } else {
                            a = 0;
                            b = -1;
                        }
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
                        g.setFont(font);
                        g.drawString("BA",
                                xpatron_offset + ch + (int) (0.35 * cell + j * cell + a - 3),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    } else {
                        g.drawString(Integer.toString(matlab[top_nr].lfu[cn][i][j]),
                                xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    }
                }
            }
        }

    }

    public void paintBTFP(Graphics g) {
        Font font = new Font("Times New Roman", Font.BOLD, 12);
        //  Font font = new Font("Monospaced", Font.BOLD, 16);
        int col = 0;
        int a;
        int b;

        g.setFont(font);

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.white);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (matlab[top_nr].btfp[cn][i][j] > 0.50) {
                        col = 8;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.40) {
                        col = 7;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.30) {
                        col = 6;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.20) {
                        col = 5;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.10) {
                        col = 4;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.05) {
                        col = 3;
                    } else if (matlab[top_nr].btfp[cn][i][j] > 0.02) {
                        col = 2;
                    } else {
                        col = 17;
                    }
                    g.setColor(grafdata.color[col]);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                    g.setColor(Color.black);
//                    g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].btfp[cn][i][j] < 0.1) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].btfp[cn][i][j] < 0.095) {
                            a = -1;
                            b = 1;
                        } else {
                            a = -5;
                            b = 0;
                        }
                    } else {
                        if (matlab[top_nr].btfp[cn][i][j] < 0.095) {
                            a = 0;
                            b = 0;
                        } else {
                            a = -4;
                            b = 0;
                        }
                    }

                    g.drawString(df0.format(100 * matlab[top_nr].btfp[cn][i][j]),
                            xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                            ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_btfp[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].btfp[cn][i][j]);
            }
        }


    }

    public void paintPOWP(Graphics g) {

        int col = 0;
        int a;
        int b;
        Font font;

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (matlab[top_nr].powp[cn][i][j] > 0.14) {
                        col = 8;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.12) {
                        col = 7;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.10) {
                        col = 6;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.08) {
                        col = 5;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.06) {
                        col = 4;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.04) {
                        col = 3;
                    } else if (matlab[top_nr].powp[cn][i][j] > 0.02) {
                        col = 2;
                    } else {
                        col = 17;
                    }
                    g.setColor(grafdata.color[col]);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
//                    g.setColor(Color.black);
//                    g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].powp[cn][i][j] < 0.1) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].powp[cn][i][j] < 0.095) {
                            a = -1;
                            b = 1;
                        } else {
                            a = -5;
                            b = 0;
                        }
                    } else {
                        if (matlab[top_nr].powp[cn][i][j] < 0.095) {
                            a = 0;
                            b = 0;
                        } else {
                            a = -4;
                            b = 0;
                        }
                    }
                    g.drawString(df0.format(100 * matlab[top_nr].powp[cn][i][j]),
                            xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                            ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                }
            }
        }

                for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_powp[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].powp[cn][i][j]);
            }
        }


    }


    public void paintTMOL(Graphics g) {

        int col = 0;
        int a;
        int b;
        Font font;

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (matlab[top_nr].tmol[cn][i][j] > 0.14) {
                        col = 8;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.12) {
                        col = 7;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.10) {
                        col = 6;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.08) {
                        col = 5;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.06) {
                        col = 4;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.04) {
                        col = 3;
                    } else if (matlab[top_nr].tmol[cn][i][j] > 0.02) {
                        col = 2;
                    } else {
                        col = 17;
                    }
                    g.setColor(grafdata.color[col]);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
//                    g.setColor(Color.black);
//                    g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].tmol[cn][i][j] < 0.1) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].tmol[cn][i][j] < 0.095) {
                            a = -1;
                            b = 1;
                        } else {
                            a = -5;
                            b = 0;
                        }
                    } else {
                        if (matlab[top_nr].tmol[cn][i][j] < 0.095) {
                            a = 0;
                            b = 0;
                        } else {
                            a = -4;
                            b = 0;
                        }
                    }
                    if (matlab[top_nr].tmol[cn][i][j] > 0) {
                        g.drawString(df0.format(100 * matlab[top_nr].tmol[cn][i][j]),
                                xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                                ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                    }
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_tmol[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].tmol[cn][i][j]);
            }
        }


    }



    public void paintEXP(Graphics g) {
        Font font = new Font("Times New Roman", Font.BOLD, 12);
        int col = 0;
        Double max = 0.0;
        g.setFont(font);
        int a;
        int b;

        try {
            matlab[top_nr].matte.java_calcexp(cn + 1);
            matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, cn + 1);
        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        }
        MWNumericArray mexp = (MWNumericArray) matvec[23];
        matlab[top_nr].exp[cn] = (double[][][]) mexp.toDoubleArray();
        MWArray.disposeArray(mexp);

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > max) {
                        max = matlab[top_nr].exp[cn][i][j][burnupslider.getValue()];
                    }
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.975 * max) {
                        col = 8;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.95 * max) {
                        col = 7;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.925 * max) {
                        col = 6;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.90 * max) {
                        col = 5;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.875 * max) {
                        col = 4;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.85 * max) {
                        col = 3;
                    } else if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] > 0.825 * max) {
                        col = 2;
                    } else {
                        col = 17;
                    }
                    g.setColor(grafdata.color[col]);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
//                    g.setColor(Color.black);
//                    g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_exp[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].exp[cn][i][j][burnupslider.getValue()]);
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[matlab[top_nr].lfu[cn][i][j]]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(Color.black);
                    if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] < 9.5) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] < 9.5) {
                            a = -1;
                            b = 1;
                        } else {
                            a = -5;
                            b = 0;
                        }
                    } else {
                        if (matlab[top_nr].exp[cn][i][j][burnupslider.getValue()] < 9.5) {
                            a = 0;
                            b = 0;
                        } else {
                            a = -4;
                            b = 0;
                        }
                    }
                    g.drawString(df0.format(matlab[top_nr].exp[cn][i][j][burnupslider.getValue()]),
                            xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                            ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                }
            }
        }

    }

    public void paintROD(Graphics g) {
//        Font font = new Font("Times New Roman", Font.BOLD, 14);
//          Font font = new Font("Monospaced", Font.BOLD, 14);
        Font font = new Font("Times New Roman", Font.BOLD, 16);
        int col = 0;
        g.setFont(font);
        int k = 0;
        int a;
        int b;

        try {
            matvec1 = matlab[top_nr].matte.java_calc_rod(7);
        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        }

        MWNumericArray mnr_rod = (MWNumericArray) matvec1[0];
        matlab[top_nr].nr_rod = mnr_rod.getInt();
        MWArray.disposeArray(mnr_rod);
        MWNumericArray mrodenr = (MWNumericArray) matvec1[1];
        matlab[top_nr].rodenr[cn] = (double[][]) mrodenr.toDoubleArray();
        MWArray.disposeArray(mrodenr);
        MWNumericArray mrodba = (MWNumericArray) matvec1[2];
        matlab[top_nr].rodba[cn] = (double[][]) mrodba.toDoubleArray();
        MWArray.disposeArray(mrodba);
        MWNumericArray mrodenr2 = (MWNumericArray) matvec1[3];
        matlab[top_nr].rodenr2[cn] = mrodenr2.getDoubleData();
        MWArray.disposeArray(mrodenr2);
        MWNumericArray mrodba2 = (MWNumericArray) matvec1[4];
        matlab[top_nr].rodba2[cn] = mrodba2.getDoubleData();
        MWArray.disposeArray(mrodba2);
        MWNumericArray mrodtype2 = (MWNumericArray) matvec1[5];
        matlab[top_nr].rodtype2[cn] = mrodtype2.getDoubleData();
        MWArray.disposeArray(mrodtype2);
        MWNumericArray mrodtype = (MWNumericArray) matvec1[6];
        matlab[top_nr].rodtype[cn] = (double[][]) mrodtype.toDoubleArray();
        MWArray.disposeArray(mrodtype);

        col = 20;
        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {
                    g.setColor(grafdata.color[col]);
                    g.fillRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
//                    g.setColor(Color.black);
//                    g.drawRect(xpatron_offset + ch + j * cell, ypatron_offset + ch + i * cell, cell, cell);
                }
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                str_rod[i + matlab[top_nr].npst * j] = df3.format(matlab[top_nr].rodenr[cn][i][j]);
            }
        }

        for (int i = 0; i < matlab[top_nr].npst; i++) {
            for (int j = 0; j < matlab[top_nr].npst; j++) {
                if (matlab[top_nr].lfu[cn][i][j] > 0) {

                    k = 0;
                    while (k < matlab[top_nr].nr_rod && matlab[top_nr].rodtype2[cn][k] != matlab[top_nr].rodtype[cn][i][j]) {
                        k = k + 1;
                    }
                    g.setColor(grafdata.color[k + 1]);
                    g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);
                    g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + j * cell),
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + i * cell),
                            (int) (rod_scale * cell),
                            (int) (rod_scale * cell));
                    g.setColor(Color.black);

                    if (k + 1 > 9) {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
                    } else {
                        font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
                    }
                    g.setFont(font);
                    if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
                        if (k + 1 > 9) {
                            a = -5;
                            b = 0;
                        } else {
                            a = -1;
                            b = 1;
                        }
                    } else {
                        if (k + 1 > 9) {
                            a = -4;
                            b = -1;
                        } else {
                            a = 0;
                            b = -1;
                        }
                    }
                    g.drawString(df0.format(k + 1),
                            //                    g.drawString(Integer.toString(matlab[top_nr].lfu[cn][i][j]),
                            xpatron_offset + ch + (int) (0.35 * cell + j * cell + a),
                            ypatron_offset + ch + (int) (0.65 * cell + i * cell + b));
                }
            }
        }

    }

    public void paintChannel(Graphics g) {
        for (int i = 0; i < 5; i++) {
            g.drawRect(xpatron_offset + i, ypatron_offset + i, matlab[top_nr].npst * cell + 9 - 2 * i, matlab[top_nr].npst * cell + 9 - 2 * i);
        }
    }

    public void paintControlRod(Graphics g) {
        g.setColor(Color.gray);
        g.fillRoundRect(100, ypatron_offset - 20, 12, patron_width + 20, 10, 10);
        g.fillRoundRect(100, ypatron_offset - 20, patron_width + 20, 12, 10, 10);

    }

    public void paintEnr(Graphics g) {
        //    Font font = new Font("Monospaced", Font.BOLD, 16);
        Font font = new Font("Times New Roman", Font.BOLD, 16);
        g.setFont(font);
        int a;
        int b;

        for (int j = 0; j < matlab[top_nr].enr1[cn].length; j++) {
            if (j < 10) {
                g.setColor(grafdata.color[matlab[top_nr].enr1[cn][j]]);
                g.fillOval((int) (xenr_offset + 0.1 * cell_enr),
                        ypatron_offset + (int) (0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
                g.setColor(Color.black);
                g.drawOval((int) (xenr_offset + 1 + 0.1 * cell_enr),
                        ypatron_offset + (int) (1 + 0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr - 2),
                        (int) (0.8 * cell_enr - 2));
                g.drawOval((int) (xenr_offset + 0.1 * cell_enr),
                        ypatron_offset + (int) (0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
            } else {
                g.setColor(grafdata.color[matlab[top_nr].enr1[cn][j]]);
                g.fillOval((int) (xenr_offset + 2.1 * cell_enr+ cell_add),
                        ypatron_offset + (int) (0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
                g.setColor(Color.black);
                g.drawOval((int) (xenr_offset + 1 + 2.1 * cell_enr+ cell_add),
                        ypatron_offset + (int) (1 + 0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr - 2),
                        (int) (0.8 * cell_enr - 2));
                g.drawOval((int) (xenr_offset + 2.1 * cell_enr+ cell_add ),
                        ypatron_offset + (int) (0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
            }
        }

        g.setColor(Color.black);
        for (int j = 0; j < matlab[top_nr].enr1[cn].length; j++) {
            if (j + 1 < 10) {
                font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
            } else {
                font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
            }
            g.setFont(font);
            if (j + 1 < 10) {
                a = 0;
                b = 0;
            } else {
                a = -4;
                b = 0;
            }
            if (j < 10) {
                if (matlab[top_nr].ba2[cn][j] > 0) {
                    font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
                    g.setFont(font);
                    g.drawString("BA",
                            //                g.drawString(Integer.toString(j + 1),
                            (int) (xenr_offset + 0.29 * cell_enr),
                            ypatron_offset + (int) (0.65 * cell_enr + j * cell_enr + b - 1));
                } else {
                    g.drawString(Integer.toString(matlab[top_nr].enr1[cn][j]),
                            (int) (xenr_offset + 0.35 * cell_enr + a),
                            ypatron_offset + (int) (0.65 * cell_enr + j * cell_enr + b));
                }
            } else {
                if (matlab[top_nr].ba2[cn][j] > 0) {
                    font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
                    g.setFont(font);
                    g.drawString("BA",
                            (int) (xenr_offset + 2.29 * cell_enr+ cell_add),
                            ypatron_offset + (int) (0.65 * cell_enr + (j - 10) * cell_enr + b - 1));
                } else {
                    g.drawString(Integer.toString(matlab[top_nr].enr1[cn][j]),
                            //                    g.drawString(Integer.toString(j + 1),
                            (int) (xenr_offset + 2.35 * cell_enr+a+ cell_add),
                            ypatron_offset + (int) (0.65 * cell_enr + (j - 10) * cell_enr + b));
                }
            }
        }

        font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
        g.setFont(font);
        for (int j = 0; j < matlab[top_nr].enr2[cn].length; j++) {
            if (j < 10) {
                if (matlab[top_nr].ba2[cn][j] > 0) {
                    g.drawString(df2.format(matlab[top_nr].enr2[cn][j]),
                            (int) (xenr_offset + 0.35 * cell_enr + 30),
                            ypatron_offset + (int) (0.45 * cell_enr + j * cell_enr));
                    g.drawString(df2.format(matlab[top_nr].ba2[cn][j]) + " BA",
                            (int) (xenr_offset + 0.35 * cell_enr + 30),
                            ypatron_offset + (int) (0.85 * cell_enr + j * cell_enr));
                } else {
                    g.drawString(df2.format(matlab[top_nr].enr2[cn][j]),
                            (int) (xenr_offset + 0.35 * cell_enr + 30),
                            ypatron_offset + (int) (0.65 * cell_enr + j * cell_enr));
                }
            } else {
                if (matlab[top_nr].ba2[cn][j] > 0) {
                    g.drawString(df2.format(matlab[top_nr].enr2[cn][j]),
                            (int) (xenr_offset + 2.45 * cell_enr + 30+ cell_add),
                            ypatron_offset + (int) (0.45 * cell_enr + (j - 10) * cell_enr));
                    g.drawString(df2.format(matlab[top_nr].ba2[cn][j]) + " BA",
                            (int) (xenr_offset + 2.45 * cell_enr + 30+ cell_add),
                            ypatron_offset + (int) (0.85 * cell_enr + (j - 10) * cell_enr));
                } else {
                    g.drawString(df2.format(matlab[top_nr].enr2[cn][j]),
                            (int) (xenr_offset + 2.45 * cell_enr + 30+ cell_add),
                            ypatron_offset + (int) (0.65 * cell_enr + (j - 10) * cell_enr));
                }
            }
        }
    }

    public void paintEnrRod(Graphics g) {

        Font font;
        int a;
        int b;
        int x1 = 0;

        if (matlab[top_nr].npst > 9) {
            x1 = 0;
        }

        for (int j = 0; j < matlab[top_nr].nr_rod; j++) {
            if (j < 10) {
                g.setColor(grafdata.color[j + 1]);
                g.fillOval((int) (xenr_offset + 0.1 * cell_enr),
                        ypatron_offset + (int) (0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
                g.setColor(Color.black);
                g.drawOval((int) (xenr_offset + 1 + 0.1 * cell_enr),
                        ypatron_offset + (int) (1 + 0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr - 2),
                        (int) (0.8 * cell_enr - 2));
                g.drawOval((int) (xenr_offset + 0.1 * cell_enr),
                        ypatron_offset + (int) (0.1 * cell_enr + j * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
            } else {
                g.setColor(grafdata.color[j + 1]);
                g.fillOval((int) (xenr_offset + 2.1 * cell_enr + x1),
                        ypatron_offset + (int) (0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
                g.setColor(Color.black);
                g.drawOval((int) (xenr_offset + 1 + 2.1 * cell_enr + x1),
                        ypatron_offset + (int) (1 + 0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr - 2),
                        (int) (0.8 * cell_enr - 2));
                g.drawOval((int) (xenr_offset + 2.1 * cell_enr + x1),
                        ypatron_offset + (int) (0.1 * cell_enr + (j - 10) * cell_enr),
                        (int) (0.8 * cell_enr),
                        (int) (0.8 * cell_enr));
            }
        }

        g.setColor(Color.black);
        for (int j = 0; j < matlab[top_nr].nr_rod; j++) {
            if (j + 1 < 10) {
                font = new Font("LucidaTypewriterBold", Font.BOLD, 16);
            } else {
                font = new Font("LucidaTypewriterBold", Font.BOLD, 14);
            }
            g.setFont(font);
            if (j + 1 < 10) {
                a = 0;
                b = 0;
            } else {
                a = -4;
                b = 0;
            }
            if (j < 10) {
                g.drawString(Integer.toString(j + 1),
                        (int) (xenr_offset + 0.35 * cell_enr + a),
                        ypatron_offset + (int) (0.65 * cell_enr + j * cell_enr + b));
            } else {
                g.drawString(Integer.toString(j + 1),
                        (int) (xenr_offset + 2.35 * cell_enr + x1 + a),
                        ypatron_offset + (int) (0.65 * cell_enr + (j - 10) * cell_enr + b));
            }
        }

        font = new Font("LucidaTypewriterBold", Font.BOLD, 12);
        g.setFont(font);
        for (int j = 0; j < matlab[top_nr].nr_rod; j++) {
            if (j < 10) {
                if (matlab[top_nr].rodba2[cn][j] > 0) {
                    g.drawString(df2.format(matlab[top_nr].rodenr2[cn][j]),
                            (int) (xenr_offset + 0.25 * cell_enr + 30),
                            ypatron_offset + (int) (0.45 * cell_enr + j * cell_enr));
                    g.drawString(df2.format(matlab[top_nr].rodba2[cn][j]) + " BA",
                            (int) (xenr_offset + 0.25 * cell_enr + 30),
                            ypatron_offset + (int) (0.85 * cell_enr + j * cell_enr));
                } else {
                    g.drawString(df2.format(matlab[top_nr].rodenr2[cn][j]),
                            (int) (xenr_offset + 0.25 * cell_enr + 30),
                            ypatron_offset + (int) (0.65 * cell_enr + j * cell_enr));
                }
            } else {
                if (matlab[top_nr].rodba2[cn][j] > 0) {
                    g.drawString(df2.format(matlab[top_nr].rodenr2[cn][j]),
                            (int) (xenr_offset + 2.45 * cell_enr + 30 + x1),
                            ypatron_offset + (int) (0.45 * cell_enr + (j - 10) * cell_enr));
                    g.drawString(df2.format(matlab[top_nr].rodba2[cn][j]) + " BA",
                            (int) (xenr_offset + 2.45 * cell_enr + 30+x1),
                            ypatron_offset + (int) (0.85 * cell_enr + (j - 10) * cell_enr));
                } else {
                    g.drawString(df2.format(matlab[top_nr].rodenr2[cn][j]),
                            (int) (xenr_offset + 2.45 * cell_enr + 30 + x1),
                            ypatron_offset + (int) (0.65 * cell_enr + (j - 10) * cell_enr));
                }
            }
        }

    }


    public void paintType(Graphics g) {

        if (matlab[top_nr].type[cn].equals("Atrium10")) {
//                g.setColor(new Color(222, 233, 244));
            g.setColor(new Color(198, 222, 246));
            g.fillRect(xpatron_offset + ch + 4 * cell, ch + ypatron_offset + 4 * cell, 3 * cell, 3 * cell);

            g.setColor(Color.black);
            for (int k = 0; k < 3; k++) {
                g.drawRect(xpatron_offset + ch + 4 * cell + k * 1, ch + ypatron_offset + 4 * cell + k * 1, 3 * cell - k * 2, 3 * cell - k * 2);
            }

        } else if (matlab[top_nr].type[cn].equals("GE14") || matlab[top_nr].type[cn].equals("GNF2")) {
            g.setColor(new Color(198, 222, 246));
            g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));
            g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));

            g.setColor(Color.black);
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell - 1),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell - 1),
                    (int) (2.5 * rod_scale * cell + 2),
                    (int) (2.5 * rod_scale * cell + 2));
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));

            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell - 1),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell - 1),
                    (int) (2.5 * rod_scale * cell + 2),
                    (int) (2.5 * rod_scale * cell + 2));
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 5 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));

        } else if (matlab[top_nr].type[cn].equals("GE11")) {
            g.setColor(new Color(198, 222, 246));
            g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell),
                    (int) (2.15 * rod_scale * cell),
                    (int) (2.15 * rod_scale * cell));
            g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell),
                    (int) (2.15 * rod_scale * cell),
                    (int) (2.15 * rod_scale * cell));

            g.setColor(Color.black);
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell - 1),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell - 1),
                    (int) (2.15 * rod_scale * cell + 2),
                    (int) (2.15 * rod_scale * cell + 2));
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell),
                    (int) (2.15 * rod_scale * cell),
                    (int) (2.15 * rod_scale * cell));

            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell - 1),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell - 1),
                    (int) (2.15 * rod_scale * cell + 2),
                    (int) (2.15 * rod_scale * cell + 2));
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 4.20 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 2.95 * cell),
                    (int) (2.15 * rod_scale * cell),
                    (int) (2.15 * rod_scale * cell));

        } else if (matlab[top_nr].type[cn].equals("GE8")) {
            g.setColor(new Color(198, 222, 246));
            g.fillOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));
            g.setColor(Color.black);
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell - 1),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell - 1),
                    (int) (2.5 * rod_scale * cell + 2),
                    (int) (2.5 * rod_scale * cell + 2));
            g.drawOval(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + 3 * cell),
                    (int) (2.5 * rod_scale * cell),
                    (int) (2.5 * rod_scale * cell));
            
        } else if (matlab[top_nr].type[cn].equals("Svea96Optima2")) {
            g.setColor(new Color(198, 222, 246));
            int nPoints = 16;
            int a = 7;
            int yp = ypatron_offset + ch;
            int xp = xpatron_offset + ch;
//            int[] xPoints = {xp + a + 5 * cell, xp + a + 5 * cell, xp + a + 4 * cell, xp + 0 * cell, xp + 0 * cell, xp + a + 4 * cell, xp + a + 5 * cell, xp + a + 5 * cell, xp - a + 6 * cell, xp - a + 6 * cell, xp - a + 7 * cell, xp + 11 * cell, xp + 11 * cell, xp - a + 7 * cell, xp - a + 6 * cell, xp - a + 6 * cell};
//            int[] yPoints = {yp + 0 * cell, yp + a + 4 * cell, yp + a + 5 * cell, yp + a + 5 * cell, yp - a + 6 * cell, yp - a + 6 * cell, yp - a + 7 * cell, yp + 11 * cell, yp + 11 * cell, yp - a + 7 * cell, yp - a + 6 * cell, yp - a + 6 * cell, yp + a + 5 * cell, yp + a + 5 * cell, yp + a + 4 * cell, yp + 0 * cell};

            int[] xxPoints = {xp + a + 5 * cell, xp + a + 5 * cell, xp + 4 * cell, xp + 0 * cell, xp + 0 * cell, xp + 4 * cell, xp + a + 5 * cell, xp + a + 5 * cell, xp - a + 6 * cell, xp - a + 6 * cell, xp + 7 * cell, xp + 11 * cell, xp + 11 * cell, xp + 7 * cell, xp - a + 6 * cell, xp - a + 6 * cell};
            int[] yyPoints = {yp + 0 * cell, yp + 4 * cell, yp + a + 5 * cell, yp + a + 5 * cell, yp - a + 6 * cell, yp - a + 6 * cell, yp + 7 * cell, yp + 11 * cell, yp + 11 * cell, yp + 7 * cell, yp - a + 6 * cell, yp - a + 6 * cell, yp + a + 5 * cell, yp + a + 5 * cell, yp + 4 * cell, yp + 0 * cell};
            g.fillPolygon(xxPoints, yyPoints, nPoints);
            g.setColor(Color.black);
            g.drawPolygon(xxPoints, yyPoints, nPoints);
        }
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        if (enrpushed) {
//            System.out.println("ENR");
            paintPatron(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            exppushed = false;
            powpushed = false;
            btfpushed = false;
            btfppushed = false;
            powppushed = false;
            rodpushed = false;
            tmolpushed = false;
        } else if (powpushed) {
//            System.out.println("POW");
            paintPow(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_pow);
            exppushed = false;
            enrpushed = false;
            btfpushed = false;
            btfppushed = false;
            powppushed = false;
            rodpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }
        } else if (btfpushed) {
            paintBTF(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_btf);
            exppushed = false;
            enrpushed = false;
            powpushed = false;
            btfppushed = false;
            powppushed = false;
            rodpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }
        } else if (btfppushed) {
            paintBTFP(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_btfp);
            exppushed = false;
            powppushed = false;
            enrpushed = false;
            powpushed = false;
            btfpushed = false;
            rodpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }
        } else if (powppushed) {
            paintPOWP(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_powp);
            exppushed = false;
            btfppushed = false;
            enrpushed = false;
            powpushed = false;
            btfpushed = false;
            rodpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }

         } else if (tmolpushed) {
            paintTMOL(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_tmol);
            exppushed = false;
            btfppushed = false;
            enrpushed = false;
            powpushed = false;
            powppushed = false;
            btfpushed = false;
            rodpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }

        } else if (exppushed) {
            paintEXP(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnr(g);
            paintType(g);
            dataList.setListData(str_exp);
            powppushed = false;
            btfppushed = false;
            enrpushed = false;
            powpushed = false;
            btfpushed = false;
            rodpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }
        } else if (rodpushed) {
            paintROD(g);
            paintChannel(g);
            paintControlRod(g);
            paintEnrRod(g);
            paintType(g);
            dataList.setListData(str_rod);
            exppushed = false;
            powppushed = false;
            btfppushed = false;
            enrpushed = false;
            powpushed = false;
            btfpushed = false;
            tmolpushed = false;
            if (datalistpushed || plusenrpushed || minusenrpushed) {
                dataList.setSelectedIndex(index);
                paintDataMark(g);
            }
        }


    }

    public void MousePressed(java.awt.event.MouseEvent evt) {
//        System.out.println("MUS");

        MWNumericArray mtmol = null;


        int x = evt.getX(); // x-coordinate where user clicked.
        int y = evt.getY(); // y-coordinate where user clicked.



        index = dataList.getSelectedIndex();

        Graphics g1 = getGraphics();

        x_pos = (x - xpatron_offset - ch) / cell;
        y_pos = (y - ypatron_offset - ch) / cell;


        x_enrpos = x - (int) (xenr_offset + 0.1 * cell_enr + cell_add);
        y_enrpos = y - ypatron_offset - (int) (0.1 * cell_enr);
        x_enrpos = x_enrpos / cell_enr;
        y_enrpos = y_enrpos / cell_enr;



//        x_enrpos = (x - xpatron_offset - ch - matlab[top_nr].npst * cell - 20) / cell_enr;
//        y_enrpos = (y - ypatron_offset - ch) / cell_enr;
        if (x_enrpos == 2) {
            x_enrpos = 1;
            y_enrpos = y_enrpos + 10;
        }

        if (btfpushed) {
            paintBTF(g1);
            paintType(g1);
        } else if (powpushed) {
            paintPow(g1);
            paintType(g1);
        } else if (enrpushed) {
            paintPatron(g1);
            paintType(g1);
        } else if (exppushed) {
            paintEXP(g1);
            paintType(g1);
        } else if (rodpushed) {
            paintROD(g1);
            paintType(g1);
         } else if (btfppushed) {
            paintBTFP(g1);
            paintType(g1);
        } else if (powppushed) {
            paintPOWP(g1);
            paintType(g1);
        }

// Bundle
        if (x > 120 && y > ypatron_offset && x < 500 && y < 500) {

            if (y_pos < matlab[top_nr].npst && matlab[top_nr].lfu[cn][x_pos][y_pos] > 0) {
                dataList.setSelectedIndex(y_pos + matlab[top_nr].npst * x_pos);
                dataList.ensureIndexIsVisible(y_pos + matlab[top_nr].npst * x_pos);
// Right mouse button
                if (evt.isMetaDown()) {
                    try {
                        for (int i = 0; i <= cnmax; i++) {
                            matlab[top_nr].matte.java_increase_tmol(i + 1, x_pos + 1, y_pos + 1);
                            matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                            mtmol = (MWNumericArray) matvec[43];
                            matlab[top_nr].tmol[i] = (double[][]) mtmol.toDoubleArray();
                            MWArray.disposeArray(mtmol);
                        }
                        paintTMOL(g1);
                        // Middle mouse button
                    } catch (MWException ex) {
                        Exceptions.printStackTrace(ex);
                    }
                } else if (evt.isAltDown()) {
                    try {
                        for (int i = 0; i <= cnmax; i++) {
                            matlab[top_nr].matte.java_decrease_tmol(i + 1, x_pos + 1, y_pos + 1);
                            matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, i + 1);
                            mtmol = (MWNumericArray) matvec[43];
                            matlab[top_nr].tmol[i] = (double[][]) mtmol.toDoubleArray();
                            MWArray.disposeArray(mtmol);
                        }
                        paintTMOL(g1);
                        // Middle mouse button
                    } catch (MWException ex) {
                        Exceptions.printStackTrace(ex);
                    }
//                    System.out.println(x);
//                    System.out.println(y);
//            System.out.println(indx);
//Left mouse button
                } else {
                    g1.setColor(Color.black);
                    for (int i = 0; i < 4; i++) {
                        g1.drawRect(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + x_pos * cell) - i,
                                ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + y_pos * cell) - i,
                                2 * i + (int) (rod_scale * cell),
                                2 * i + (int) (rod_scale * cell));
                    }
                }
            }
        }

        index = dataList.getSelectedIndex();
//        System.out.println(x);
//        System.out.println(y);
        System.out.println(x_enrpos);
        System.out.println(y_enrpos);

// Pellets
        if (x > xenr_offset && x < xenr_offset + 3*cell_enr+ cell_add && y < 10 * cell_enr + ypatron_offset && y > ypatron_offset && !rodpushed) {
            if (y_enrpos < matlab[top_nr].enr2[cn].length) {
                paintU235andBA(g1);
            }
        }
        g1.dispose();
    }

    public void paintDataMark(Graphics g) {


        if (btfpushed || powpushed || exppushed || rodpushed || powppushed || btfppushed) {

            int x = index / matlab[top_nr].npst;
            int y = index - x * matlab[top_nr].npst;

            //      System.out.println("Data point nr " + index + "  x = " + x + "  y = " + y);
            g.setColor(Color.black);
            if (matlab[top_nr].lfu[cn][x][y] > 0) {
                for (int i = 0; i < 4; i++) {
                    g.drawRect(xpatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + x * cell) - i,
                            ypatron_offset + (int) (ch + (1 - rod_scale) / 2 * cell + y * cell) - i,
                            2 * i + (int) (rod_scale * cell),
                            2 * i + (int) (rod_scale * cell));
                }
            }
        }
    }

    public void paintU235andBA(Graphics g) {

        FuelPanel content = new FuelPanel(this, matlab[top_nr]);
        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Fuel enrichment of Bundle "+ top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog fuelDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        fuelDialog.setVisible(true);

//        if (dialogDescriptor.getValue() == DialogDescriptor.OK_OPTION) {
//            System.out.println("The user chose OK");
//        }
    }

    public void paintAxial(Graphics g) {

        AxialPanel content = new AxialPanel(this, matlab[top_nr]);

//        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Axial Panel", true,
//                new Object[]{DialogDescriptor.OK_OPTION, DialogDescriptor.CANCEL_OPTION},
//                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Axial of Bundle " + top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);





        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);

//        if (dialogDescriptor.getValue() == DialogDescriptor.OK_OPTION) {
//            System.out.println("The user chose OK");
//        }
    }


//        public void paintOptimize(Graphics g) {
//
//        OptimizePanel content = new OptimizePanel(this, matlab);
//
//        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Automatic optimizing", true,
//                new Object[]{DialogDescriptor.OK_OPTION, DialogDescriptor.CANCEL_OPTION},
//                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);
//
//        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
//        axialDialog.setVisible(true);
//    }
    public void paintOptimize(Graphics g) {

//        JFrame optimize_window = new JFrame("Automatic optimizing of Bundle "+ top_nr);
//        OptimizePanel content = new OptimizePanel(this, this.matlab[top_nr]);
//
//        optimize_window.setContentPane(content);
//        optimize_window.pack();
////             fuel_window.setSize(x_size / 2, y_size / 2);
//        optimize_window.setLocation(200, 200);
//        optimize_window.setResizable(true);
//        optimize_window.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
//        optimize_window.setVisible(true);

        OptimizePanel content = new OptimizePanel(this, this.matlab[top_nr], top_nr);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Automatic optimizing of Bundle " + top_nr, false,
//            DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Automatic optimizing of Bundle " + top_nr, true,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);

    }

    public void paintCasmo(Graphics g) {

//        JFrame casmo_window = new JFrame("Start Casmo");
//        casmopanel = new CasmoPanel(this, matlab);
//
//        casmo_window.setContentPane(casmopanel);
//        casmo_window.pack();
//        casmo_window.setLocation(200, 200);
//        casmo_window.setResizable(true);
//        casmo_window.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
//        casmo_window.setVisible(true);
        CasmoPanel content = new CasmoPanel(this, matlab[top_nr]);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(content, "Start Casmo of Bundle "+ top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);

    }

    public void paintPlot(Graphics g) {



        PlotPanel plotpanel = new PlotPanel(this, matlab[top_nr]);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(plotpanel, "Plot of Bundle "+ top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);

//        demo.pack();
//        RefineryUtilities.centerFrameOnScreen(demo);
//        demo.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
//        demo.setVisible(true);
    }

    public void paintBowing(Graphics g) {


        BowPanel bowpanel = new BowPanel(this, matlab[top_nr]);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(bowpanel, "Channel Bowing of Bundle "+ top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);


    }

       public void paintData(Graphics g) {


        DataPanel datapanel = new DataPanel(this, matlab[top_nr]);

        DialogDescriptor dialogDescriptor = new DialogDescriptor(datapanel, "Bundle Data "+ top_nr, false,
                new Object[]{DialogDescriptor.OK_OPTION},
                DialogDescriptor.CANCEL_OPTION, DialogDescriptor.DEFAULT_ALIGN, null, null);

        Dialog axialDialog = DialogDisplayer.getDefault().createDialog(dialogDescriptor);
        axialDialog.setVisible(true);


    }


    public synchronized void update() {

        MWNumericArray mnr_rod = null;
        MWNumericArray mrodenr = null;
        MWNumericArray mrodba = null;
        MWNumericArray mrodenr2 = null;
        MWNumericArray mrodba2 = null;
        MWNumericArray mrodtype2 = null;
        MWNumericArray mrodtype = null;
        MWNumericArray mbtf = null;
        MWNumericArray mlfu = null;
        MWNumericArray mu235 = null;
        MWNumericArray menr2 = null;
        MWNumericArray mba2 = null;
        MWNumericArray mkinf = null;
        MWNumericArray mpow = null;
        MWNumericArray mtmol = null;
        MWNumericArray mbtfax_env = null;
        MWNumericArray mmaxbtfax_env = null;
        MWNumericArray mmaxbtfax = null;
        MWNumericArray moldmaxbtfax = null;
        MWNumericArray mmaxbtf = null;
        MWNumericArray mbtfp = null;
        MWNumericArray mfint = null;
        MWNumericArray mpowp = null;
        MWNumericArray mbtfax = null;
        MWNumericArray mexp = null;
        MWNumericArray mplotmaxfint = null;
        MWNumericArray mplotmaxbtf = null;
        MWNumericArray mplotminbtf = null;
        MWNumericArray mplotmaxkinf = null;
        MWNumericArray mplotminkinf = null;


        for (int i = 0; i <= cnmax; i++) {
            try {
                matlab[top_nr].matte.java_bigcalc(i + 1);
                matlab[top_nr].matte.java_calcexp(i + 1);
                matlab[top_nr].matte.java_calcbtf(i + 1);
            } catch (MWException ex) {
                Exceptions.printStackTrace(ex);
            }
        }

        try {
            matvec1 = matlab[top_nr].matte.java_calcbtfax(1);
            matlab[top_nr].matDispose(matvec1);
            matvec1 = matlab[top_nr].matte.java_calcbtfaxenv(3);
            matlab[top_nr].matDispose(matvec1);

            matvec1 = matlab[top_nr].matte.java_calc_tmol_limit(matlab[top_nr].ba_tmol, matlab[top_nr].plr_tmol,
                    matlab[top_nr].corner_tmol, matlab[top_nr].aut_ba, matlab[top_nr].ba_limit, matlab[top_nr].plr_limit,
                    matlab[top_nr].corner_limit);

            matlab[top_nr].matDispose(matvec1);
            

            matvec1 = matlab[top_nr].matte.java_calc_rod(7);
            mnr_rod = (MWNumericArray) matvec1[0];
            matlab[top_nr].nr_rod = mnr_rod.getInt();
            MWArray.disposeArray(mnr_rod);
            mrodenr = (MWNumericArray) matvec1[1];
            matlab[top_nr].rodenr[cn] = (double[][]) mrodenr.toDoubleArray();
            MWArray.disposeArray(mrodenr);
            mrodba = (MWNumericArray) matvec1[2];
            matlab[top_nr].rodba[cn] = (double[][]) mrodba.toDoubleArray();
            MWArray.disposeArray(mrodba);
            mrodenr2 = (MWNumericArray) matvec1[3];
            matlab[top_nr].rodenr2[cn] = mrodenr2.getDoubleData();
            MWArray.disposeArray(mrodenr2);
            mrodba2 = (MWNumericArray) matvec1[4];
            matlab[top_nr].rodba2[cn] = mrodba2.getDoubleData();
            MWArray.disposeArray(mrodba2);
            mrodtype2 = (MWNumericArray) matvec1[5];
            matlab[top_nr].rodtype2[cn] = mrodtype2.getDoubleData();
            MWArray.disposeArray(mrodtype2);
            mrodtype = (MWNumericArray) matvec1[6];
            matlab[top_nr].rodtype[cn] = (double[][]) mrodtype.toDoubleArray();
            MWArray.disposeArray(mrodtype);
            matlab[top_nr].matDispose(matvec1);

        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        }

        for (int m = 0; m <= cnmax; m++) {
            if (ax_check[m].isSelected()) {
                try {
//                    matvec1 = matlab[top_nr].matte.java_calc_bow(m + 1, 5.0);
                    matvec = matlab[top_nr].matte.java_get_matlab_data(matlab[top_nr].nr_outputs, m + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }
                mbtf = (MWNumericArray) matvec[5];
                matlab[top_nr].btf[m] = (double[][][]) mbtf.toDoubleArray();
                MWArray.disposeArray(mbtf);
                mlfu = (MWNumericArray) matvec[1];
                matlab[top_nr].lfu[m] = (int[][]) mlfu.toIntArray();
                MWArray.disposeArray(mlfu);
                mu235 = (MWNumericArray) matvec[10];
                matlab[top_nr].u235[m] = mu235.getDouble();
                MWArray.disposeArray(mu235);
                menr2 = (MWNumericArray) matvec[6];
                matlab[top_nr].enr2[m] = menr2.getDoubleData();
                MWArray.disposeArray(menr2);
                mba2 = (MWNumericArray) matvec[7];
                matlab[top_nr].ba2[m] = mba2.getDoubleData();
                MWArray.disposeArray(mba2);
                mkinf = (MWNumericArray) matvec[8];
                matlab[top_nr].kinf[m] = mkinf.getDoubleData();
                MWArray.disposeArray(mkinf);
                mpow = (MWNumericArray) matvec[2];
                matlab[top_nr].pow[m] = (double[][][]) mpow.toDoubleArray();
                MWArray.disposeArray(mpow);
                mbtfax_env = (MWNumericArray) matvec[12];
                matlab[top_nr].btfax_env[m] = (double[][]) mbtfax_env.toDoubleArray();
                MWArray.disposeArray(mbtfax_env);
                mmaxbtfax_env = (MWNumericArray) matvec[16];
                matlab[top_nr].maxbtfax_env[m] = mmaxbtfax_env.getDouble();
                MWArray.disposeArray(mmaxbtfax_env);
                mmaxbtfax = (MWNumericArray) matvec[15];
                matlab[top_nr].maxbtfax[m] = mmaxbtfax.getDoubleData();
                MWArray.disposeArray(mmaxbtfax);
                mmaxbtf = (MWNumericArray) matvec[14];
                matlab[top_nr].maxbtf[m] = mmaxbtf.getDoubleData();
                MWArray.disposeArray(mmaxbtf);
                mbtfp = (MWNumericArray) matvec[21];
                matlab[top_nr].btfp[m] = (double[][]) mbtfp.toDoubleArray();
                MWArray.disposeArray(mbtfp);
                mfint = (MWNumericArray) matvec[13];
                matlab[top_nr].fint[m] = mfint.getDoubleData();
                MWArray.disposeArray(mfint);
                mpowp = (MWNumericArray) matvec[22];
                matlab[top_nr].powp[m] = (double[][]) mpowp.toDoubleArray();
                MWArray.disposeArray(mpowp);
                mbtfax = (MWNumericArray) matvec[11];
                matlab[top_nr].btfax[m] = (double[][][]) mbtfax.toDoubleArray();
                MWArray.disposeArray(mbtfax);
                mexp = (MWNumericArray) matvec[23];
                matlab[top_nr].exp[m] = (double[][][]) mexp.toDoubleArray();
                MWArray.disposeArray(mexp);
                mrodenr = (MWNumericArray) matvec[24];
                matlab[top_nr].rodenr[m] = (double[][]) mrodenr.toDoubleArray();
                MWArray.disposeArray(mrodenr);
                mtmol = (MWNumericArray) matvec[43];
                matlab[top_nr].tmol[m] = (double[][]) mtmol.toDoubleArray();
                MWArray.disposeArray(mtmol);
//                matlab[top_nr].matDispose(matvec);


            }
        }
        try {
            matvec1 = matlab[top_nr].matte.java_get_plotdata(5);
        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        }
        mplotmaxfint = (MWNumericArray) matvec1[0];
        matlab[top_nr].plotmaxfint = mplotmaxfint.getDouble();
        MWArray.disposeArray(mplotmaxfint);
        mplotmaxbtf = (MWNumericArray) matvec1[1];
        matlab[top_nr].plotmaxbtf = mplotmaxbtf.getDouble();
        MWArray.disposeArray(mplotmaxbtf);
        mplotminbtf = (MWNumericArray) matvec1[2];
        matlab[top_nr].plotminbtf = mplotminbtf.getDouble();
        MWArray.disposeArray(mplotminbtf);
        mplotmaxkinf = (MWNumericArray) matvec1[3];
        matlab[top_nr].plotmaxkinf = mplotmaxkinf.getDouble();
        MWArray.disposeArray(mplotmaxkinf);
        mplotminkinf = (MWNumericArray) matvec1[4];
        matlab[top_nr].plotminkinf = mplotminkinf.getDouble();
        MWArray.disposeArray(mplotminkinf);
        matlab[top_nr].matDispose(matvec1);

        fint_str = df3.format(matlab[top_nr].fint[cn][burnupslider.getValue()]);
        if (axial_btf_check.isSelected() && fkinf_check.isSelected()) {
            btf_str = "  <BTF(kinf)> = " + df3.format(matlab[top_nr].maxbtfax_env[cn]);
        } else if (axial_btf_check.isSelected()) {
            btf_str = "  <BTF> = " + df3.format(matlab[top_nr].maxbtfax[cn][burnupslider.getValue()]);
        } else {
            btf_str = "  BTF = " + df3.format(matlab[top_nr].maxbtf[cn][burnupslider.getValue()]);
        }

        point_message.setText("Burnup = " + matlab[top_nr].burnup[cn][burnupslider.getValue()]
                + "   kinf = " + matlab[top_nr].kinf[cn][burnupslider.getValue()]
                + "   fint = " + fint_str
                + btf_str);

        if (axial_btf_check.isSelected()) {
            u235_str = "<U235> = " + df3.format(matlab[top_nr].mean_u235);
        } else {
            u235_str = "U235 = " + df3.format(matlab[top_nr].u235[cn]);
        }
        u235_message.setText(u235_str);
        repaint();

    }

}
