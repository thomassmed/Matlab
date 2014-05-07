'COM' ********************************************************
'COM' *                                                      *
'COM' * Include file for Peripheral and Reactor system and   *
'COM' * components, eg. Pump characteristics, Loop data etc. *
'COM' *                                                      *
'COM' ********************************************************

'COM' ********************************************************
'COM' PER.CAL ON  = Activate the BWR Peripheral Systems model
'COM' PER.CAL OFF = Do not activate BWR Per. Systems model
'COM' ********************************************************
'PER.CAL'  'ON'                                             / * PERIPHERALS (M.K. 061115)

'COM' ********************************************************
'COM' PER.MOD – BWR Peripheral Systems Calculation Modes
'COM' 'PUMP' = Adjust PUMP speed for Press.Balance
'COM' 'FWT'  = FeedWater Temperature search               
'COM' ********************************************************
'PER.MOD'  'PUMP' 'FWT'                                     / * OPTION (M.K. 061115)

'PER.FDW'  158.2                                            / * FEEDWATER temp Initial value
'PER.CAR'  0.0 0.003                                        / * Carry under etc. (M.K. 061115)

'COM' ********************************************************
'COM' Stean separator and Steam Dome data
'COM' ********************************************************
'PER.SEP'  165 6.263 7.103 8.823 5.022 11.508 13.0          / * STEAM SEPARATOR (M.K. 061115) 11=>13 sme test
'PER.DOM'  184.073                                          / * STEAM DOME (M.K. 061115)

'COM' ********************************************************
'COM' Volumes and Hydraulik data for different regions
'COM' ********************************************************
'PER.UPP'  5.012  26.611 20.38                              / * UPPER PLENUM (M.K. 061115)
'COM' 'PER.BLK'  7.897  28.6   72.98643                           / * BULK REGION (M.K. 061115)
'PER.BLK'  7.400  28.6   72.98643                           / * BULK REGION (M.K. 061115) (C.J 7.400 061129)
'PER.DCR'  5.459 108.0036 1.253   8.867                     / * DOWNCOMER (M.K. 061115)
'COM' 'PER.RCP'  8  4    0.6    0.0  1                            / * RCP LOOP DATA (M.K. 061115)
'PER.RCP'  8  4    0.6    0.0   2.35                        / * RCP LOOP DATA (M.K. 061115) (C.J 2.35 061123)
'PER.LPL' -4.341  54.551  0.146   5.273                     / * LOWER PLENUM * (M.K. 061115)

'COM' ********************************************************
'COM' Pump data and modelling
'COM' ********************************************************
'PER.PMP'  'INTERNAL'  1325.   1.91  31.0  350.  350.      / * PUMP DATA (M.K. 061115)
'PER.PCV'  'TAB'                                            
     0.      1.42
     0.20    1.26
     0.40    1.18
     0.60    1.16
     0.80    1.12
     0.90    1.07
     1.0     1.0
     1.18    0.82
     1.33    0.50
     1.54    0.0
     2.22   -5.14 /
'PER.TRQ'  740. 3805. 0.009  20.0                          / * PUMP DATA * BF1 is fictitious data  (M.K. 061115)
'PER.TCV'  'TAB'                                            
     0.      0.77
     0.20    0.78
     0.40    0.80
     0.60    0.87
     0.80    0.95
     0.90    0.98
     1.0     1.0
     1.25    0.61
     1.67    0.15
     1.82   -0.08   /
