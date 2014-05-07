/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.studsvik;

import com.mathworks.toolbox.javabuilder.MWArray;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import java.text.DecimalFormat;
import matlab.mdata;
import org.openide.util.Exceptions;

/**
 *
 * @author kjell
 */
public class MatLab {

    int[][][] lfu;
    int[][][] lpi;
    double[][][][] pow;
    double[][][][] pow_crd;
    double[][][][] exp;
    double[][][][] btf;
    double[][][][] btfax;
    double[][][] btfax_env;
    double[][][] rodenr;
    double[][][] rodba;
    double[][][] rodtype;
    double[][] burnup;
    double[][] kinf;
    double[][] enr2;
    int[][] enr1;
    int[][] nr_enr;
    int[][] nr_rod2;
    double[][] ba2;
    double[][] rodenr2;
    double[][] rodba2;
    double[][] rodtype2;
    double[][][] enr;
    double[][][] ba;
    double[][] axial_zone;
    double[][] fint;
    double[][] oldfint;
    double[][] maxbtf;
    double[][] maxbtfax;
    double[][] oldmaxbtfax;
    double[][][] btfp;
    double[][][] tmol;
    double[][][] powp;
    double[][] standard_u235;
    Object[] matvec = null;
    Object[] matvec1 = null;
    mdata matte = null;
//    static mdata matte = null;
    MWNumericArray mba2;
    MWNumericArray menr2;
    MWNumericArray menr1;
    MWNumericArray mnr_enr;
    MWNumericArray mnr_rod2;
    MWNumericArray mba;
    MWNumericArray menr;
    MWNumericArray mrodba2;
    MWNumericArray mrodenr2;
    MWNumericArray mrodtype2;
    MWNumericArray mlfu;
    MWNumericArray mpow;
    MWNumericArray mpow_crd;
    MWNumericArray mexp;
    MWNumericArray mlpi;
    MWNumericArray mrodenr;
    MWNumericArray mrodba;
    MWNumericArray mrodtype;
    MWNumericArray mburnup;
    MWNumericArray mkinf;
    MWNumericArray mmaxbtf;
    MWNumericArray mmaxbtfax;
    MWNumericArray moldmaxbtfax;
    MWNumericArray mmaxbtfax_env;
    MWNumericArray mbtf;
    MWNumericArray mbtfp;
    MWNumericArray mtmol;
    MWNumericArray mpowp;
    MWNumericArray mbtfax;
    MWNumericArray mbtfax_env;
    MWNumericArray maxial_zone;
    MWNumericArray mnpst;
    MWNumericArray mNlfu;
    MWNumericArray mNrods;
    MWNumericArray mnr_rod;
    MWNumericArray mu235;
    MWNumericArray mfint;
    MWNumericArray moldfint;
    MWNumericArray mmean_u235;
    MWNumericArray mstandard_u235;
    MWCharArray mcaifile;
    MWCharArray mcaxfile;
    MWCharArray mtype;
    MWCharArray msim;
    MWNumericArray mNburnup;
    String file;
    String[] files;
    int npst;
    int[] Nlfu;
    int[] Nburnup;
    int nr;
    int nr_rod;
    int Nrods;
    double[] u235;
    double mean_u235;
    double[] maxbtfax_env;
    int[][][] lpi1;
    int nr_outputs;
    double[][][] max_fint_tab;
    double[][][] max_btf_tab;
    double[] corner_limit;
    double[] ba_limit;
    double[] plr_limit;
    double[] ba_tmol;
    double[] corner_tmol;
    double[] plr_tmol;
    double[] aut_ba;
    double[] sel_rods;
    double[] maxfint;
    double[] maxbtf_limit;
    double[] max_burnup;
    String[] caxfile;
    String[] caifile;
    String[] type;
    String[] sim;
    DecimalFormat df0 = new DecimalFormat("#");
    double plotmaxfint;
    double plotoldmaxfint;
    double plotmaxbtf;
    double plotminbtf;
    double plotoldmaxbtf;
    double plotoldminbtf;
    double plotmaxkinf;
    double plotminkinf;
    MWNumericArray mplotmaxfint;
    MWNumericArray mplotoldmaxfint;
    MWNumericArray mplotmaxbtf;
    MWNumericArray mplotminbtf;
    MWNumericArray mplotoldmaxbtf;
    MWNumericArray mplotoldminbtf;
    MWNumericArray mplotmaxkinf;
    MWNumericArray mplotminkinf;


    public MatLab(String[] caxfiles, Double[] axial) {


        try {
            files = caxfiles;

            if (matte == null) {
                matte = new mdata();
            }

            axial_zone = new double[files.length][files.length];

            for (int m = 0; m < files.length; m++) {
                axial_zone[m][0] = axial[0]/axial[files.length-1];
                for (int i = 0; i < files.length - 1; i++) {
                    axial_zone[m][i + 1] = (axial[i + 1] - axial[i]) / axial[files.length - 1];
                }
            }

            int defaul_axial = 0;
            if (axial[0] == 0) {
                defaul_axial = 1;
            }

            matte.java_init((Object[]) files);
            matvec1 = matte.java_calc_rod(7);
            matDispose(matvec1);


            lfu = new int[files.length][][];
            pow = new double[files.length][][][];
            pow_crd = new double[files.length][][][];
            exp = new double[files.length][][][];
            btf = new double[files.length][][][];
            btfax = new double[files.length][][][];
            btfp = new double[files.length][][];
            tmol = new double[files.length][][];
            powp = new double[files.length][][];
            burnup = new double[files.length][];
            lpi = new int[files.length][][];
            enr2 = new double[files.length][];
            enr1 = new int[files.length][];
            nr_enr = new int[files.length][];
            nr_rod2 = new int[files.length][];
            ba2 = new double[files.length][];
            enr = new double[files.length][][];
            ba = new double[files.length][][];
            kinf = new double[files.length][];
            u235 = new double[files.length];
            btfax_env = new double[files.length][][];
            fint = new double[files.length][];
            oldfint = new double[files.length][];
            maxbtf = new double[files.length][];
            maxbtfax = new double[files.length][];
            oldmaxbtfax = new double[files.length][];
            maxbtfax_env = new double[files.length];
            standard_u235 = new double[files.length][];
            rodenr = new double[files.length][][];
            rodba = new double[files.length][][];
            rodtype = new double[files.length][][];
            max_fint_tab = new double[files.length][5][2];
            max_btf_tab = new double[files.length][5][2];
            corner_limit = new double[files.length];
            ba_limit = new double[files.length];
            plr_limit = new double[files.length];
            ba_tmol = new double[files.length];
            corner_tmol = new double[files.length];
            plr_tmol = new double[files.length];
            aut_ba = new double[files.length];
            sel_rods = new double[files.length];
            maxfint = new double[files.length];
            maxbtf_limit = new double[files.length];
            max_burnup = new double[files.length];
            rodenr2 = new double[files.length][];
            rodba2 = new double[files.length][];
            rodtype2 = new double[files.length][];
            caxfile = new String[files.length];
            caifile = new String[files.length];
            type = new String[files.length];
            sim = new String[files.length];
            Nburnup = new int[files.length];
            Nlfu = new int[files.length];

            nr_outputs = 45;


            if (defaul_axial == 0) {
                for (int i = 0; i < files.length; i++) {
                    for (int j = 0; j < files.length; j++) {
                        matte.java_axial_spinner_callback(i + 1, j + 1, axial_zone[i][j]);
                    }
                }
                matte.java_calcbtfax(1);
            }


            for (int i = 0; i < files.length; i++) {
                for (int m = 0; m < 5; m++) {
                    max_fint_tab[i][m][1] = 1.25;
                    max_btf_tab[i][m][1] = 0.98;
                }
                max_fint_tab[i][0][0] = 0;
                max_fint_tab[i][1][0] = 5;
                max_fint_tab[i][2][0] = 10;
                max_fint_tab[i][3][0] = 20;
                max_fint_tab[i][4][0] = 30;
                max_btf_tab[i][0][0] = 0;
                max_btf_tab[i][1][0] = 5;
                max_btf_tab[i][2][0] = 10;
                max_btf_tab[i][3][0] = 20;
                max_btf_tab[i][4][0] = 30;

                corner_limit[i] = 1.0;
                ba_limit[i] = 1.0;
                plr_limit[i] = 1.0;
                ba_tmol[i] = 0;
                corner_tmol[i] = 0;
                plr_tmol[i] = 0;
                aut_ba[i] = 0;
                sel_rods[i] = 0;
                maxfint[i] = 1.25;
                maxbtf_limit[i] = 0.97;
                max_burnup[i] = 30;

                matvec = matte.java_get_matlab_data(nr_outputs, i + 1);
//                System.out.println(files[i]);
//                mnpst = (MWNumericArray) matvec[0];
//                npst = mnpst.getInt();
                mlfu = (MWNumericArray) matvec[1];
                lfu[i] = (int[][]) mlfu.toIntArray();
//                System.out.println(lfu[0][0][0]);
                mpow = (MWNumericArray) matvec[2];
                pow[i] = (double[][][]) mpow.toDoubleArray();
//                System.out.println(pow[0][0][0][0]);
                mburnup = (MWNumericArray) matvec[3];
                burnup[i] = mburnup.getDoubleData();
                mlpi = (MWNumericArray) matvec[4];
                lpi[i] = (int[][]) mlpi.toIntArray();
                mbtf = (MWNumericArray) matvec[5];
                btf[i] = (double[][][]) mbtf.toDoubleArray();
//            System.out.println(btf[0][0][0]);
                menr2 = (MWNumericArray) matvec[6];
                enr2[i] = menr2.getDoubleData();
                mba2 = (MWNumericArray) matvec[7];
                ba2[i] = mba2.getDoubleData();
                mkinf = (MWNumericArray) matvec[8];
                kinf[i] = mkinf.getDoubleData();

                if (defaul_axial == 1) {
                    maxial_zone = (MWNumericArray) matvec[9];
                    axial_zone[i] = maxial_zone.getDoubleData();
                }

//            System.out.println(matvec[9]);
                mu235 = (MWNumericArray) matvec[10];
                u235[i] = mu235.getDouble();
//            System.out.println(u235);
                mbtfax = (MWNumericArray) matvec[11];
                btfax[i] = (double[][][]) mbtfax.toDoubleArray();
//            System.out.println(btfax[0][0][0]);
                mbtfax_env = (MWNumericArray) matvec[12];
                btfax_env[i] = (double[][]) mbtfax_env.toDoubleArray();
                mfint = (MWNumericArray) matvec[13];
                fint[i] = mfint.getDoubleData();
//                System.out.println(fint[0][0]);
                mmaxbtf = (MWNumericArray) matvec[14];
                maxbtf[i] = mmaxbtf.getDoubleData();
                mmaxbtfax = (MWNumericArray) matvec[15];

                maxbtfax[i] = mmaxbtfax.getDoubleData();

                moldmaxbtfax=(MWNumericArray) matvec[15];
                oldmaxbtfax[i] = moldmaxbtfax.getDoubleData();

                mmaxbtfax_env = (MWNumericArray) matvec[16];
                maxbtfax_env[i] = mmaxbtfax_env.getDouble();
                mmean_u235 = (MWNumericArray) matvec[17];
                mean_u235 = mmean_u235.getDouble();
                mstandard_u235 = (MWNumericArray) matvec[18];
                standard_u235[i] = mstandard_u235.getDoubleData();
//                System.out.println(matvec[18]);
//                System.out.println(standard_u235[0][0]);
                mba = (MWNumericArray) matvec[19];
                ba[i] = (double[][]) mba.toDoubleArray();
                menr = (MWNumericArray) matvec[20];
                enr[i] = (double[][]) menr.toDoubleArray();
                mbtfp = (MWNumericArray) matvec[21];
                btfp[i] = (double[][]) mbtfp.toDoubleArray();
                mpowp = (MWNumericArray) matvec[22];
                powp[i] = (double[][]) mbtfp.toDoubleArray();
                mexp = (MWNumericArray) matvec[23];
                exp[i] = (double[][][]) mexp.toDoubleArray();
//                System.out.println(exp[0][0][0][0]);

                mrodenr = (MWNumericArray) matvec[24];
                rodenr[i] = (double[][]) mrodenr.toDoubleArray();
                mrodba = (MWNumericArray) matvec[25];
                rodba[i] = (double[][]) mrodba.toDoubleArray();
                mrodenr2 = (MWNumericArray) matvec[26];
                rodenr2[i] = mrodenr2.getDoubleData();
                mrodba2 = (MWNumericArray) matvec[27];
                rodba2[i] = mrodba2.getDoubleData();
                mrodtype2 = (MWNumericArray) matvec[28];
                rodtype2[i] = mrodtype2.getDoubleData();
                mrodtype = (MWNumericArray) matvec[29];
                rodtype[i] = (double[][]) mrodtype.toDoubleArray();

                mcaxfile = (MWCharArray) matvec[31];
                caxfile[i] = mcaxfile.toString();
//                System.out.println(caxfile[i]);

                mcaifile = (MWCharArray) matvec[32];
                caifile[i] = mcaifile.toString();
//                System.out.println(caifile[i]);
                mtype = (MWCharArray) matvec[33];
                type[i] = mtype.toString();

                mNburnup = (MWNumericArray) matvec[34];
                Nburnup[i] = mNburnup.getInt();
                menr1 = (MWNumericArray) matvec[35];
                enr1[i] = menr1.getIntData();

                msim = (MWCharArray) matvec[36];
                sim[i] = msim.toString();

                mnr_enr = (MWNumericArray) matvec[37];
                nr_enr[i] = mnr_enr.getIntData();

                mNlfu = (MWNumericArray) matvec[38];
                Nlfu[i] = mNlfu.getInt();

                mnr_rod2 = (MWNumericArray) matvec[39];
                nr_rod2[i] = mnr_enr.getIntData();

                moldfint = (MWNumericArray) matvec[42];
                oldfint[i] = moldfint.getDoubleData();

                mtmol = (MWNumericArray) matvec[43];
                tmol[i] = (double[][]) mbtfp.toDoubleArray();

                mpow_crd = (MWNumericArray) matvec[44];
                pow_crd[i] = (double[][][]) mpow_crd.toDoubleArray();

                String[] ss;
                ss = sim[i].split("SIM");
                sim[i] = ss[1].toString();

                matte.java_calc_maxfint_tab(i + 1, max_fint_tab[i]);
                matte.java_calc_maxbtf_tab(i + 1, max_btf_tab[i]);

            }


            matvec1 = matte.java_calc_mean_u235(1);
            mmean_u235 = (MWNumericArray) matvec1[0];
            mean_u235 = mmean_u235.getDouble();

            mnpst = (MWNumericArray) matvec[0];
            npst = mnpst.getInt();
            mnr_rod = (MWNumericArray) matvec[30];
            nr_rod = mnr_rod.getInt();
            mNrods = (MWNumericArray) matvec[40];
            Nrods = mNrods.getInt();


            matvec1 = matte.java_get_plotdata(8);
            mplotmaxfint = (MWNumericArray) matvec1[0];
            plotmaxfint = mplotmaxfint.getDouble();
            mplotmaxbtf = (MWNumericArray) matvec1[1];
            plotmaxbtf = mplotmaxbtf.getDouble();
            mplotminbtf = (MWNumericArray) matvec1[2];
            plotminbtf = mplotminbtf.getDouble();
            mplotmaxkinf = (MWNumericArray) matvec1[3];
            plotmaxkinf = mplotmaxkinf.getDouble();
            mplotminkinf = (MWNumericArray) matvec1[4];
            plotminkinf = mplotminkinf.getDouble();
            mplotoldmaxfint = (MWNumericArray) matvec1[5];
            plotoldmaxfint = mplotmaxfint.getDouble();
            mplotoldmaxbtf = (MWNumericArray) matvec1[6];
            plotoldmaxbtf = mplotoldmaxbtf.getDouble();
            mplotoldminbtf = (MWNumericArray) matvec1[7];
            plotoldminbtf = mplotoldminbtf.getDouble();


            matDispose(matvec1);
            matDispose(matvec);

        } catch (MWException ex) {
            Exceptions.printStackTrace(ex);
        } finally {
            MWArray.disposeArray(mba2);
            MWArray.disposeArray(menr2);
            MWArray.disposeArray(mba);
            MWArray.disposeArray(menr);
            MWArray.disposeArray(mrodba2);
            MWArray.disposeArray(mrodenr2);
            MWArray.disposeArray(mrodtype2);
            MWArray.disposeArray(mlfu);
            MWArray.disposeArray(mpow);
            MWArray.disposeArray(mpow_crd);
            MWArray.disposeArray(mexp);
            MWArray.disposeArray(mlpi);
            MWArray.disposeArray(mrodenr);
            MWArray.disposeArray(mrodba);
            MWArray.disposeArray(mrodtype);
            MWArray.disposeArray(mburnup);
            MWArray.disposeArray(mkinf);
            MWArray.disposeArray(mmaxbtf);
            MWArray.disposeArray(mmaxbtfax);
            MWArray.disposeArray(mmaxbtfax_env);
            MWArray.disposeArray(mbtf);
            MWArray.disposeArray(mbtfp);
            MWArray.disposeArray(mtmol);
            MWArray.disposeArray(mpowp);
            MWArray.disposeArray(mbtfax);
            MWArray.disposeArray(mbtfax_env);
            MWArray.disposeArray(maxial_zone);
            MWArray.disposeArray(mnpst);
            MWArray.disposeArray(mnr_rod);
            MWArray.disposeArray(mu235);
            MWArray.disposeArray(mfint);
            MWArray.disposeArray(mmean_u235);
            MWArray.disposeArray(mstandard_u235);
            MWArray.disposeArray(mcaifile);
            MWArray.disposeArray(mcaxfile);
            MWArray.disposeArray(mtype);
            MWArray.disposeArray(mNburnup);
            MWArray.disposeArray(mplotmaxfint);
            MWArray.disposeArray(mplotmaxbtf);
            MWArray.disposeArray(mplotminbtf);
            MWArray.disposeArray(mplotmaxkinf);
            MWArray.disposeArray(mplotminkinf);
            MWArray.disposeArray(menr1);
            MWArray.disposeArray(msim);
            MWArray.disposeArray(mnr_enr);
            MWArray.disposeArray(mNlfu);
            MWArray.disposeArray(mnr_rod2);
            MWArray.disposeArray(mNrods);
        }

    }

    public final void matDispose(Object[] matObject) {
        for (int i = 0; i < matObject.length; i++) {
            MWArray.disposeArray(matObject[i]);
        }
    }
}
