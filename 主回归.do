// gen ln_max_amout=ln(max_amount)
// // gen ln_penalty=ln(penalt)
// egen region=group(province)
// egen time=group(year)
// gen lnamout_2=ln_max_amout^2

// gen pre_lnamount=ln_max_amout*pre
// gen after_lnamount=ln_max_amout*after

// gen after_lnamount_2=lnamout_2*after
winsor2 ln_max_amout lnamout_2
*总体
*大部分none为非pre
// gen pre_lnamount=pre*ln_max_amout
// gen sec_lnamout=second*ln_max_amout
// gen thi_lnamout=third*ln_max_amout
// gen fou_lnamout=fourth*ln_max_amout

// gen sec_lnamout2=second*lnamout_2
// gen thi_lnamout2=third*lnamout_2
// gen fou_lnamout2=fourth*lnamout_2

*all 前后
qui reghdfe actual_sen ln_max_amout_w  lnamout_2_w second third fourth  if pre==1, absorb(time region) vce(clsuter region)
est sto reg0
qui reghdfe actual_sen ln_max_amout_w  lnamout_2_w second third fourth  if pre==0, absorb(time region) vce(clsuter region)
est sto reg1
esttab  reg0 reg1 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle("pre" "after")

*一二次交互项
qui reghdfe actual_sen ln_max_amout lnamout_2  after pre_lnamount pre_lnamount_2 if rank=="second", absorb(time region) vce(clsuter region)
est sto reg1
qui reghdfe actual_sen ln_max_amout lnamout_2 after  pre_lnamount pre_lnamount_2 if rank=="third", absorb(time region) vce(clsuter region)
est sto reg2
qui reghdfe actual_sen ln_max_amout lnamout_2 after  pre_lnamount pre_lnamount_2  if rank=="fourth", absorb(time region) vce(clsuter region)
est sto reg3
esttab  reg0 reg1 reg2 reg3 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle("all" "second" "third" "fourth")

*一次交互项
qui reghdfe actual_sen ln_max_amout lnamout_2  after after_lnamount  if rank=="second", absorb(time region) vce(clsuter region)
est sto reg1
qui reghdfe actual_sen ln_max_amout lnamout_2 after  after_lnamount  if rank=="third", absorb(time region) vce(clsuter region)
est sto reg2
qui reghdfe actual_sen ln_max_amout lnamout_2 after  after_lnamount  if rank=="fourth", absorb(time region) vce(clsuter region)
est sto reg3
esttab  reg1 reg2 reg3 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle( "second" "third" "fourth")

*二次交互项
qui reghdfe actual_sen ln_max_amout lnamout_2  after  after_lnamount_2 if rank=="second", absorb(time region) vce(clsuter region)
est sto reg1
qui reghdfe actual_sen ln_max_amout lnamout_2 after  after_lnamount_2 if rank=="third", absorb(time region) vce(clsuter region)
est sto reg2
qui reghdfe actual_sen ln_max_amout lnamout_2 after   after_lnamount_2  if rank=="fourth", absorb(time region) vce(clsuter region)
est sto reg3
esttab  reg1 reg2 reg3 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle( "second" "third" "fourth")

*pre
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="second"&pre==1, absorb(time region) vce(clsuter region)
est sto reg1
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="third"&pre==1, absorb(time region) vce(clsuter region)
est sto reg2
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="fourth"&pre==1, absorb(time region) vce(clsuter region)
est sto reg3
esttab  reg1 reg2 reg3 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle( "second" "third" "fourth")

*after
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="second"&(after==1|between==1), absorb(time region) vce(clsuter region)
est sto reg1
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="third"&(after==1|between==1), absorb(time region) vce(clsuter region)
est sto reg2
qui reghdfe actual_sen ln_max_amout lnamout_2  if rank=="fourth"&(after==1|between==1), absorb(time region) vce(clsuter region)
est sto reg3

esttab  reg1 reg2 reg3 ,scalars(N r2 r2_a F df_m)  star(* 0.1 ** 0.05 *** 0.01) mtitle( "second" "third" "fourth")

*描述统计
tabstat actual_sen sentence probation ln_max_amout year month day ln_penalty pre between after first second third fourth ,s(N mean p50 sd min max) f(%12.2f) c(s)
