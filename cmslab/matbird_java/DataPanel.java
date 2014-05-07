package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import java.awt.Color;
import java.awt.Dimension;
import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import org.openide.util.Exceptions;

public class DataPanel extends JPanel {

    public MainPanel mainpanel1;
    public MatLab matlab1;
    private JTextArea textArea;
    String space1 = "          ";
    String space2 = "        ";

    public DataPanel(MainPanel mainpanel, MatLab matlab) {

        matlab1 = matlab;
        mainpanel1 = mainpanel;

        setBackground(Color.white);
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(null);
        setPreferredSize(new Dimension(400, 600));

        JPanel panel1 = new JPanel();
        panel1.setBackground(Color.white);
//        panel1.setBackground(Color.green);
        panel1.setBounds(10, 20, 370, 40);
        add(panel1);

        JLabel fuellabel1 = new JLabel("Fuel type:  " + matlab1.type[0], JLabel.LEFT);
        fuellabel1.setFont(mainpanel1.font_button);
        panel1.add(fuellabel1);

        JLabel fuellabel2 = new JLabel("        ", JLabel.LEFT);
        panel1.add(fuellabel2);

        javax.swing.JButton pellets = new javax.swing.JButton("Pellets");
        pellets.setFont(mainpanel1.font_button);
        panel1.add(pellets);
        pellets.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {
                    matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, mainpanel1.cn + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }

                matlab1.mnr_enr = (MWNumericArray) matlab1.matvec[37];
                matlab1.nr_enr[mainpanel1.cn] = matlab1.mnr_enr.getIntData();
                MWArray.disposeArray(matlab1.mnr_enr);
                matlab1.menr2 = (MWNumericArray) matlab1.matvec[6];
                matlab1.enr2[mainpanel1.cn] = matlab1.menr2.getDoubleData();
                MWArray.disposeArray(matlab1.menr2);
                matlab1.mba2 = (MWNumericArray) matlab1.matvec[7];
                matlab1.ba2[mainpanel1.cn] = matlab1.mba2.getDoubleData();
                MWArray.disposeArray(matlab1.mba2);
                matlab1.mNlfu = (MWNumericArray) matlab1.matvec[38];
                matlab1.Nlfu[mainpanel1.cn] = matlab1.mNlfu.getInt();
                MWArray.disposeArray(matlab1.mNlfu);

                String sss = "Number of pellts\n\n"
                        + "Number      U235           BA\n";
                textArea.setRows(matlab1.nr_enr[mainpanel1.cn].length + 5);
                textArea.setText(sss);
                String[] nr_enr = new String[matlab1.nr_enr[mainpanel1.cn].length];
                String[] enr2 = new String[matlab1.enr2[mainpanel1.cn].length];
                String[] ba2 = new String[matlab1.ba2[mainpanel1.cn].length];

                for (int i = 0; i < matlab1.enr2[mainpanel1.cn].length; i++) {
                    nr_enr[i] = Integer.toString(matlab1.nr_enr[mainpanel1.cn][i]);
                    enr2[i] = mainpanel1.df2.format(matlab1.enr2[mainpanel1.cn][i]);

                    if (matlab1.ba2[mainpanel1.cn][i] == 0) {
                        ba2[i] = space2;
                    } else {
                        ba2[i] = Double.toString(matlab1.ba2[mainpanel1.cn][i]);
                    }

                    if (matlab1.nr_enr[mainpanel1.cn][i] > 9) {
                        textArea.append(space2 + nr_enr[i] + space1 + enr2[i] + space1 + ba2[i] + "\n");
                    } else {
                        textArea.append(space1 + nr_enr[i] + space1 + enr2[i] + space1 + ba2[i] + "\n");
                    }
                }
                textArea.append("\n" + "Total number" + space1 + matlab1.Nlfu[mainpanel1.cn] + "\n");
            }
        });

        javax.swing.JButton rods = new javax.swing.JButton("Rods");
        rods.setFont(mainpanel1.font_button);
        panel1.add(rods);
        rods.addActionListener(new java.awt.event.ActionListener() {

            @Override
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                try {
                    matlab1.matvec1 = matlab1.matte.java_calc_rod(7);
                    matlab1.matvec = matlab1.matte.java_get_matlab_data(matlab1.nr_outputs, mainpanel1.cn + 1);
                } catch (MWException ex) {
                    Exceptions.printStackTrace(ex);
                }

                matlab1.mnr_rod2 = (MWNumericArray) matlab1.matvec[39];
                matlab1.nr_rod2[mainpanel1.cn] = matlab1.mnr_rod2.getIntData();
                MWArray.disposeArray(matlab1.mnr_rod2);
                matlab1.mnr_rod = (MWNumericArray) matlab1.matvec[30];
                matlab1.nr_rod = matlab1.mnr_rod.getInt();
                MWArray.disposeArray(matlab1.mnr_rod);
                matlab1.mrodenr2 = (MWNumericArray) matlab1.matvec[26];
                matlab1.rodenr2[mainpanel1.cn] = matlab1.mrodenr2.getDoubleData();
                MWArray.disposeArray(matlab1.mrodenr2);
                matlab1.mrodba2 = (MWNumericArray) matlab1.matvec[27];
                matlab1.rodba2[mainpanel1.cn] = matlab1.mrodba2.getDoubleData();
                MWArray.disposeArray(matlab1.mrodba2);

                String sss = "Number of Rods\n\n"
                        + "Number      U235           BA\n";
                textArea.setRows(matlab1.nr_rod + 5);
                textArea.setText(sss);
                String[] nr_rod2 = new String[matlab1.nr_rod];
                String[] rodenr2 = new String[matlab1.rodenr2[mainpanel1.cn].length];
                String[] rodba2 = new String[matlab1.rodba2[mainpanel1.cn].length];

                for (int i = 0; i < matlab1.nr_rod; i++) {
                    nr_rod2[i] = Integer.toString(matlab1.nr_rod2[mainpanel1.cn][i]);
                    rodenr2[i] = mainpanel1.df2.format(matlab1.rodenr2[mainpanel1.cn][i]);
                    if (matlab1.rodba2[mainpanel1.cn][i] == 0) {
                        rodba2[i] = space2;
                    } else {
                        rodba2[i] = mainpanel1.df2.format(matlab1.rodba2[mainpanel1.cn][i]);
                    }

                    if (matlab1.nr_rod2[mainpanel1.cn][i] > 9) {
                        textArea.append(space2 + nr_rod2[i] + space1 + rodenr2[i] + space1 + rodba2[i] + "\n");
                    } else {
                        textArea.append(space1 + nr_rod2[i] + space1 + rodenr2[i] + space1 + rodba2[i] + "\n");
                    }
                }
                textArea.append("\n" + "Total number" + space1 + matlab1.Nrods + "\n");
            }
        });

        JPanel panel2 = new JPanel();
        panel2.setBackground(Color.white);
//        panel2.setBackground(Color.green);
        panel2.setBounds(10, 70, 370, 520);
        add(panel2);

        textArea = new JTextArea("  ", 15, 25);
        panel2.add(textArea);

    }
}
