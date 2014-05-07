/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import java.awt.BorderLayout;
import java.awt.Color;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Logger;
import javax.swing.BorderFactory;
import javax.swing.JFileChooser;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.openide.util.Exceptions;
import org.openide.util.NbBundle;
import org.openide.windows.TopComponent;
import org.openide.windows.WindowManager;
//import org.openide.util.ImageUtilities;
import org.netbeans.api.settings.ConvertAsProperties;

/**
 * Top component which displays something.
 */
@ConvertAsProperties(dtd = "-//org.studsvik//Bundle5//EN",
autostore = false)
public final class Bundle5TopComponent extends TopComponent {

    private static Bundle5TopComponent instance;
    /** path to the icon used by the component and its open action */
//    static final String ICON_PATH = "SET/PATH/TO/ICON/HERE";
    private static final String PREFERRED_ID = "Bundle5TopComponent";
    private MainPanel mainpanel5;
    private String[] caxfiles5;
    private MatLab matlab5;
    private Double[] axial5;
    String[] ss;

    public Bundle5TopComponent() {

        setName(NbBundle.getMessage(Bundle5TopComponent.class, "CTL_Bundle5TopComponent"));
        setToolTipText(NbBundle.getMessage(Bundle5TopComponent.class, "HINT_Bundle5TopComponent"));
        try {
            UIManager.setLookAndFeel("com.sun.java.swing.plaf.gtk.GTKLookAndFeel");
        } catch (ClassNotFoundException ex) {
            Exceptions.printStackTrace(ex);
        } catch (InstantiationException ex) {
            Exceptions.printStackTrace(ex);
        } catch (IllegalAccessException ex) {
            Exceptions.printStackTrace(ex);
        } catch (UnsupportedLookAndFeelException ex) {
            Exceptions.printStackTrace(ex);
        }
//        setIcon(ImageUtilities.loadImage(ICON_PATH, true));

                JFileChooser fc = new JFileChooser();
        fc.setMultiSelectionEnabled(true);
        fc.showOpenDialog(this);
        File[] files = fc.getSelectedFiles();
        int nr_files = files.length;

        ss = new String[2];

        if (nr_files == 1) {
            String onefile = files[0].getAbsolutePath();
            int dotPos = onefile.lastIndexOf(".");
            String filetype = onefile.substring(dotPos);
            if (filetype.equals(".matb")) {
                try {
                    FileReader file = new FileReader(onefile);
                    BufferedReader br = new BufferedReader(file);
                    String s;
                    try {
                        nr_files = 0;
                        while ((s = br.readLine()) != null) {
                            nr_files++;
                            System.out.println(s);
                        }
                        caxfiles5 = new String[nr_files];
                        axial5 = new Double[nr_files];
                        FileReader file2 = new FileReader(onefile);
                        BufferedReader br2 = new BufferedReader(file2);
                        int j = 0;
                        while ((s = br2.readLine()) != null) {
                            ss = s.split("#");
//                            System.out.println(ss[1]);
                            axial5[j] = Double.valueOf(ss[1]);
//                            System.out.println(axial5[j]);
                            caxfiles5[j] = ss[0].toString();
                            j++;
                        }
                    } catch (IOException ex) {
                        Exceptions.printStackTrace(ex);
                    }
                } catch (FileNotFoundException ex) {
                    Exceptions.printStackTrace(ex);
                }
            } else {
                caxfiles5 = new String[nr_files];
                axial5 = new Double[nr_files];
                for (int i = 0; i < nr_files; i++) {
                    caxfiles5[i] = files[i].getAbsolutePath();
                    axial5[i] = 0.0;
                }
            }
        } else {
            caxfiles5 = new String[nr_files];
            axial5 = new Double[nr_files];
            for (int i = 0; i < nr_files; i++) {
                caxfiles5[i] = files[i].getAbsolutePath();
                axial5[i] = 0.0;
            }
        }



//        matlab[5] = new MatLab(caxfiles5);
        matlab5 = new MatLab(caxfiles5, axial5);
//        mainpanel5 = new MainPanel(caxfiles5, matlab5);
        mainpanel5 = new MainPanel(caxfiles5, 5, matlab5);
        initComponents();
        setBorder(BorderFactory.createLineBorder(Color.GRAY, 5));
        setLayout(new BorderLayout());
        mainpanel5.addMouseListener(new java.awt.event.MouseAdapter() {

            @Override
            public void mousePressed(java.awt.event.MouseEvent evt) {
                mainpanel5.MousePressed(evt);
            }
        });

        add(mainpanel5, BorderLayout.CENTER);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
    /**
     * Gets default instance. Do not use directly: reserved for *.settings files only,
     * i.e. deserialization routines; otherwise you could get a non-deserialized instance.
     * To obtain the singleton instance, use {@link #findInstance}.
     */
    public static synchronized Bundle5TopComponent getDefault() {
        if (instance == null) {
            instance = new Bundle5TopComponent();
        }
        return instance;
    }

    /**
     * Obtain the Bundle5TopComponent instance. Never call {@link #getDefault} directly!
     */
    public static synchronized Bundle5TopComponent findInstance() {
        TopComponent win = WindowManager.getDefault().findTopComponent(PREFERRED_ID);
        if (win == null) {
            Logger.getLogger(Bundle5TopComponent.class.getName()).warning(
                    "Cannot find " + PREFERRED_ID + " component. It will not be located properly in the window system.");
            return getDefault();
        }
        if (win instanceof Bundle5TopComponent) {
            return (Bundle5TopComponent) win;
        }
        Logger.getLogger(Bundle5TopComponent.class.getName()).warning(
                "There seem to be multiple components with the '" + PREFERRED_ID
                + "' ID. That is a potential source of errors and unexpected behavior.");
        return getDefault();
    }

    @Override
    public int getPersistenceType() {
//        return TopComponent.PERSISTENCE_ALWAYS;
        return TopComponent.PERSISTENCE_NEVER;
    }

    @Override
    public void componentOpened() {
        // TODO add custom code on component opening
    }

    @Override
    public void componentClosed() {
        // TODO add custom code on component closing
    }

    void writeProperties(java.util.Properties p) {
        // better to version settings since initial version as advocated at
        // http://wiki.apidesign.org/wiki/PropertyFiles
        p.setProperty("version", "1.0");
        // TODO store your settings
    }

    Object readProperties(java.util.Properties p) {
        if (instance == null) {
            instance = this;
        }
        instance.readPropertiesImpl(p);
        return instance;
    }

    private void readPropertiesImpl(java.util.Properties p) {
        String version = p.getProperty("version");
        // TODO read your settings according to their version
    }

    @Override
    protected String preferredID() {
        return PREFERRED_ID;
    }
}
