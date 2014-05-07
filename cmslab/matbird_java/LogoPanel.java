/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.net.URL;
import javax.swing.JPanel;

/**
 *
 * @author kjell
 */
public class LogoPanel extends JPanel {

    public Image Studsvik;
//    public LogoPanel logopanel;
    public ClassLoader cl;
    public URL imageURL;

    public LogoPanel() {
        setBackground(Color.white);
//          setBackground(Color.red);
        cl = LogoPanel.class.getClassLoader();
        imageURL = cl.getResource("/home/matbird/studsvik.jpeg");
//        URL imageURL = cl.getResource("studsvik.jpeg");


        if (imageURL != null) {
            Studsvik = Toolkit.getDefaultToolkit().createImage(imageURL);
        }
    }

    public void paintComponent() {
        Graphics g1 = getGraphics();
        super.paintComponent(g1);

//        g.drawImage(Studsvik, 5, 5, 75, 17, this);
        g1.drawImage(Studsvik, 20, 20, 75, 17, this);
//        g.drawString("DDD", 10,10);
    }
}
