view: diversions_by_care_request {
  derived_table: {
    sql:
WITH inspkg AS (
SELECT DISTINCT
    package_id,
    er_diversion,
    nine_one_one_diversion,
    observation_diversion,
    hospitalization_diversion
    FROM public.insurance_plans
    WHERE er_diversion IS NOT NULL
    GROUP BY 1,2,3,4,5),
chnpkg AS (
SELECT DISTINCT
    id AS channel_item_id,
    er_diversion,
    nine_one_one_diversion,
    observation_diversion,
    hospitalization_diversion
    FROM public.channel_items
    WHERE er_diversion IS NOT NULL
    GROUP BY 1,2,3,4,5)
SELECT DISTINCT
  dcf.care_request_id,
  ic.package_id_coalese AS insurance_package_id,
  ic.custom_insurance_grouping,
  CASE WHEN
  GREATEST(dcf.diagnosis_only * df1.dc1,
  dcf.survey_yes_to_er * df1.dc2,
  dcf.diversion_911 * df1.dc3,
  dcf.pos_snf * df1.dc4,
  dcf.pos_al * df1.dc5,
  dcf.referral * df1.dc6,
  dcf.after_hours * df1.dc7,
  dcf.abnormal_vitals * df1.dc8,
  dcf.confusion * df1.dc9,
  dcf.wheelchair_hb * df1.dc10,
  dcf.ekg * df1.dc11,
  dcf.nebulizer * df1.dc12,
  dcf.iv_fluids * df1.dc13,
  dcf.blood_tests * df1.dc14,
  dcf.catheter_placement * df1.dc15,
  dcf.laceration_repair * df1.dc16,
  dcf.epistaxis * df1.dc17,
  dcf.hernia_rp_reduction * df1.dc18,
  dcf.joint_reduction * df1.dc19,
  dcf.gastronomy_tube * df1.dc20,
  dcf.abscess_drain * df1.dc21,
  dcf.dc22 * df1.dc22,
  dcf.dc23 * df1.dc23,
  dcf.dc24 * df1.dc24,
  dcf.dc25 * df1.dc25,
  dcf.dc26 * df1.dc26,
  dcf.dc27 * df1.dc27,
  dcf.dc28 * df1.dc28,
  dcf.dc29 * df1.dc29,
  dcf.dc30 * df1.dc30,
  dcf.dc31 * df1.dc31,
  dcf.dc32 * df1.dc32,
  dcf.dc33 * df1.dc33,
  dcf.dc34 * df1.dc34,
  dcf.dc35 * df1.dc35,
  dcf.dc36 * df1.dc36,
  dcf.dc37 * df1.dc37,
  dcf.dc38 * df1.dc38,
  dcf.dc39 * df1.dc39,
  dcf.dc40 * df1.dc40,
  dcf.dc41 * df1.dc41,
  dcf.diagnosis_only * df2.dc1,
  dcf.survey_yes_to_er * df2.dc2,
  dcf.diversion_911 * df2.dc3,
  dcf.pos_snf * df2.dc4,
  dcf.pos_al * df2.dc5,
  dcf.referral * df2.dc6,
  dcf.after_hours * df2.dc7,
  dcf.abnormal_vitals * df2.dc8,
  dcf.confusion * df2.dc9,
  dcf.wheelchair_hb * df2.dc10,
  dcf.ekg * df2.dc11,
  dcf.nebulizer * df2.dc12,
  dcf.iv_fluids * df2.dc13,
  dcf.blood_tests * df2.dc14,
  dcf.catheter_placement * df2.dc15,
  dcf.laceration_repair * df2.dc16,
  dcf.epistaxis * df2.dc17,
  dcf.hernia_rp_reduction * df2.dc18,
  dcf.joint_reduction * df2.dc19,
  dcf.gastronomy_tube * df2.dc20,
  dcf.abscess_drain * df2.dc21,
  dcf.dc22 * df2.dc22,
  dcf.dc23 * df2.dc23,
  dcf.dc24 * df2.dc24,
  dcf.dc25 * df2.dc25,
  dcf.dc26 * df2.dc26,
  dcf.dc27 * df2.dc27,
  dcf.dc28 * df2.dc28,
  dcf.dc29 * df2.dc29,
  dcf.dc30 * df2.dc30,
  dcf.dc31 * df2.dc31,
  dcf.dc32 * df2.dc32,
  dcf.dc33 * df2.dc33,
  dcf.dc34 * df2.dc34,
  dcf.dc35 * df2.dc35,
  dcf.dc36 * df2.dc36,
  dcf.dc37 * df2.dc37,
  dcf.dc38 * df2.dc38,
  dcf.dc39 * df2.dc39,
  dcf.dc40 * df2.dc40,
  dcf.dc41 * df2.dc41,
  dcf.diagnosis_only * df3.dc1,
  dcf.survey_yes_to_er * df3.dc2,
  dcf.diversion_911 * df3.dc3,
  dcf.pos_snf * df3.dc4,
  dcf.pos_al * df3.dc5,
  dcf.referral * df3.dc6,
  dcf.after_hours * df3.dc7,
  dcf.abnormal_vitals * df3.dc8,
  dcf.confusion * df3.dc9,
  dcf.wheelchair_hb * df3.dc10,
  dcf.ekg * df3.dc11,
  dcf.nebulizer * df3.dc12,
  dcf.iv_fluids * df3.dc13,
  dcf.blood_tests * df3.dc14,
  dcf.catheter_placement * df3.dc15,
  dcf.laceration_repair * df3.dc16,
  dcf.epistaxis * df3.dc17,
  dcf.hernia_rp_reduction * df3.dc18,
  dcf.joint_reduction * df3.dc19,
  dcf.gastronomy_tube * df3.dc20,
  dcf.abscess_drain * df3.dc21,
  dcf.dc22 * df3.dc22,
  dcf.dc23 * df3.dc23,
  dcf.dc24 * df3.dc24,
  dcf.dc25 * df3.dc25,
  dcf.dc26 * df3.dc26,
  dcf.dc27 * df3.dc27,
  dcf.dc28 * df3.dc28,
  dcf.dc29 * df3.dc29,
  dcf.dc30 * df3.dc30,
  dcf.dc31 * df3.dc31,
  dcf.dc32 * df3.dc32,
  dcf.dc33 * df3.dc33,
  dcf.dc34 * df3.dc34,
  dcf.dc35 * df3.dc35,
  dcf.dc36 * df3.dc36,
  dcf.dc37 * df3.dc37,
  dcf.dc38 * df3.dc38,
  dcf.dc39 * df3.dc39,
  dcf.dc40 * df3.dc40,
  dcf.dc41 * df3.dc41) > 0 THEN 1 ELSE 0 END AS diversion_er,
  CASE WHEN
  GREATEST(dcf.diagnosis_only * df4.dc1,
  dcf.survey_yes_to_er * df4.dc2,
  dcf.diversion_911 * df4.dc3,
  dcf.pos_snf * df4.dc4,
  dcf.pos_al * df4.dc5,
  dcf.referral * df4.dc6,
  dcf.after_hours * df4.dc7,
  dcf.abnormal_vitals * df4.dc8,
  dcf.confusion * df4.dc9,
  dcf.wheelchair_hb * df4.dc10,
  dcf.ekg * df4.dc11,
  dcf.nebulizer * df4.dc12,
  dcf.iv_fluids * df4.dc13,
  dcf.blood_tests * df4.dc14,
  dcf.catheter_placement * df4.dc15,
  dcf.laceration_repair * df4.dc16,
  dcf.epistaxis * df4.dc17,
  dcf.hernia_rp_reduction * df4.dc18,
  dcf.joint_reduction * df4.dc19,
  dcf.gastronomy_tube * df4.dc20,
  dcf.abscess_drain * df4.dc21,
  dcf.dc22 * df4.dc22,
  dcf.dc23 * df4.dc23,
  dcf.dc24 * df4.dc24,
  dcf.dc25 * df4.dc25,
  dcf.dc26 * df4.dc26,
  dcf.dc27 * df4.dc27,
  dcf.dc28 * df4.dc28,
  dcf.dc29 * df4.dc29,
  dcf.dc30 * df4.dc30,
  dcf.dc31 * df4.dc31,
  dcf.dc32 * df4.dc32,
  dcf.dc33 * df4.dc33,
  dcf.dc34 * df4.dc34,
  dcf.dc35 * df4.dc35,
  dcf.dc36 * df4.dc36,
  dcf.dc37 * df4.dc37,
  dcf.dc38 * df4.dc38,
  dcf.dc39 * df4.dc39,
  dcf.dc40 * df4.dc40,
  dcf.dc41 * df4.dc41,
  dcf.diagnosis_only * df5.dc1,
  dcf.survey_yes_to_er * df5.dc2,
  dcf.diversion_911 * df5.dc3,
  dcf.pos_snf * df5.dc4,
  dcf.pos_al * df5.dc5,
  dcf.referral * df5.dc6,
  dcf.after_hours * df5.dc7,
  dcf.abnormal_vitals * df5.dc8,
  dcf.confusion * df5.dc9,
  dcf.wheelchair_hb * df5.dc10,
  dcf.ekg * df5.dc11,
  dcf.nebulizer * df5.dc12,
  dcf.iv_fluids * df5.dc13,
  dcf.blood_tests * df5.dc14,
  dcf.catheter_placement * df5.dc15,
  dcf.laceration_repair * df5.dc16,
  dcf.epistaxis * df5.dc17,
  dcf.hernia_rp_reduction * df5.dc18,
  dcf.joint_reduction * df5.dc19,
  dcf.gastronomy_tube * df5.dc20,
  dcf.abscess_drain * df5.dc21,
  dcf.dc22 * df5.dc22,
  dcf.dc23 * df5.dc23,
  dcf.dc24 * df5.dc24,
  dcf.dc25 * df5.dc25,
  dcf.dc26 * df5.dc26,
  dcf.dc27 * df5.dc27,
  dcf.dc28 * df5.dc28,
  dcf.dc29 * df5.dc29,
  dcf.dc30 * df5.dc30,
  dcf.dc31 * df5.dc31,
  dcf.dc32 * df5.dc32,
  dcf.dc33 * df5.dc33,
  dcf.dc34 * df5.dc34,
  dcf.dc35 * df5.dc35,
  dcf.dc36 * df5.dc36,
  dcf.dc37 * df5.dc37,
  dcf.dc38 * df5.dc38,
  dcf.dc39 * df5.dc39,
  dcf.dc40 * df5.dc40,
  dcf.dc41 * df5.dc41,
  dcf.diagnosis_only * df6.dc1,
  dcf.survey_yes_to_er * df6.dc2,
  dcf.diversion_911 * df6.dc3,
  dcf.pos_snf * df6.dc4,
  dcf.pos_al * df6.dc5,
  dcf.referral * df6.dc6,
  dcf.after_hours * df6.dc7,
  dcf.abnormal_vitals * df6.dc8,
  dcf.confusion * df6.dc9,
  dcf.wheelchair_hb * df6.dc10,
  dcf.ekg * df6.dc11,
  dcf.nebulizer * df6.dc12,
  dcf.iv_fluids * df6.dc13,
  dcf.blood_tests * df6.dc14,
  dcf.catheter_placement * df6.dc15,
  dcf.laceration_repair * df6.dc16,
  dcf.epistaxis * df6.dc17,
  dcf.hernia_rp_reduction * df6.dc18,
  dcf.joint_reduction * df6.dc19,
  dcf.gastronomy_tube * df6.dc20,
  dcf.abscess_drain * df6.dc21,
  dcf.dc22 * df6.dc22,
  dcf.dc23 * df6.dc23,
  dcf.dc24 * df6.dc24,
  dcf.dc25 * df6.dc25,
  dcf.dc26 * df6.dc26,
  dcf.dc27 * df6.dc27,
  dcf.dc28 * df6.dc28,
  dcf.dc29 * df6.dc29,
  dcf.dc30 * df6.dc30,
  dcf.dc31 * df6.dc31,
  dcf.dc32 * df6.dc32,
  dcf.dc33 * df6.dc33,
  dcf.dc34 * df6.dc34,
  dcf.dc35 * df6.dc35,
  dcf.dc36 * df6.dc36,
  dcf.dc37 * df6.dc37,
  dcf.dc38 * df6.dc38,
  dcf.dc39 * df6.dc39,
  dcf.dc40 * df6.dc40,
  dcf.dc41 * df6.dc41) > 0 THEN 1 ELSE 0 END AS diversion_911,
  CASE WHEN
  GREATEST(dcf.diagnosis_only * df7.dc1,
  dcf.survey_yes_to_er * df7.dc2,
  dcf.diversion_911 * df7.dc3,
  dcf.pos_snf * df7.dc4,
  dcf.pos_al * df7.dc5,
  dcf.referral * df7.dc6,
  dcf.after_hours * df7.dc7,
  dcf.abnormal_vitals * df7.dc8,
  dcf.confusion * df7.dc9,
  dcf.wheelchair_hb * df7.dc10,
  dcf.ekg * df7.dc11,
  dcf.nebulizer * df7.dc12,
  dcf.iv_fluids * df7.dc13,
  dcf.blood_tests * df7.dc14,
  dcf.catheter_placement * df7.dc15,
  dcf.laceration_repair * df7.dc16,
  dcf.epistaxis * df7.dc17,
  dcf.hernia_rp_reduction * df7.dc18,
  dcf.joint_reduction * df7.dc19,
  dcf.gastronomy_tube * df7.dc20,
  dcf.abscess_drain * df7.dc21,
  dcf.dc22 * df7.dc22,
  dcf.dc23 * df7.dc23,
  dcf.dc24 * df7.dc24,
  dcf.dc25 * df7.dc25,
  dcf.dc26 * df7.dc26,
  dcf.dc27 * df7.dc27,
  dcf.dc28 * df7.dc28,
  dcf.dc29 * df7.dc29,
  dcf.dc30 * df7.dc30,
  dcf.dc31 * df7.dc31,
  dcf.dc32 * df7.dc32,
  dcf.dc33 * df7.dc33,
  dcf.dc34 * df7.dc34,
  dcf.dc35 * df7.dc35,
  dcf.dc36 * df7.dc36,
  dcf.dc37 * df7.dc37,
  dcf.dc38 * df7.dc38,
  dcf.dc39 * df7.dc39,
  dcf.dc40 * df7.dc40,
  dcf.dc41 * df7.dc41,
  dcf.diagnosis_only * df8.dc1,
  dcf.survey_yes_to_er * df8.dc2,
  dcf.diversion_911 * df8.dc3,
  dcf.pos_snf * df8.dc4,
  dcf.pos_al * df8.dc5,
  dcf.referral * df8.dc6,
  dcf.after_hours * df8.dc7,
  dcf.abnormal_vitals * df8.dc8,
  dcf.confusion * df8.dc9,
  dcf.wheelchair_hb * df8.dc10,
  dcf.ekg * df8.dc11,
  dcf.nebulizer * df8.dc12,
  dcf.iv_fluids * df8.dc13,
  dcf.blood_tests * df8.dc14,
  dcf.catheter_placement * df8.dc15,
  dcf.laceration_repair * df8.dc16,
  dcf.epistaxis * df8.dc17,
  dcf.hernia_rp_reduction * df8.dc18,
  dcf.joint_reduction * df8.dc19,
  dcf.gastronomy_tube * df8.dc20,
  dcf.abscess_drain * df8.dc21,
  dcf.dc22 * df8.dc22,
  dcf.dc23 * df8.dc23,
  dcf.dc24 * df8.dc24,
  dcf.dc25 * df8.dc25,
  dcf.dc26 * df8.dc26,
  dcf.dc27 * df8.dc27,
  dcf.dc28 * df8.dc28,
  dcf.dc29 * df8.dc29,
  dcf.dc30 * df8.dc30,
  dcf.dc31 * df8.dc31,
  dcf.dc32 * df8.dc32,
  dcf.dc33 * df8.dc33,
  dcf.dc34 * df8.dc34,
  dcf.dc35 * df8.dc35,
  dcf.dc36 * df8.dc36,
  dcf.dc37 * df8.dc37,
  dcf.dc38 * df8.dc38,
  dcf.dc39 * df8.dc39,
  dcf.dc40 * df8.dc40,
  dcf.dc41 * df8.dc41,
  dcf.diagnosis_only * df9.dc1,
  dcf.survey_yes_to_er * df9.dc2,
  dcf.diversion_911 * df9.dc3,
  dcf.pos_snf * df9.dc4,
  dcf.pos_al * df9.dc5,
  dcf.referral * df9.dc6,
  dcf.after_hours * df9.dc7,
  dcf.abnormal_vitals * df9.dc8,
  dcf.confusion * df9.dc9,
  dcf.wheelchair_hb * df9.dc10,
  dcf.ekg * df9.dc11,
  dcf.nebulizer * df9.dc12,
  dcf.iv_fluids * df9.dc13,
  dcf.blood_tests * df9.dc14,
  dcf.catheter_placement * df9.dc15,
  dcf.laceration_repair * df9.dc16,
  dcf.epistaxis * df9.dc17,
  dcf.hernia_rp_reduction * df9.dc18,
  dcf.joint_reduction * df9.dc19,
  dcf.gastronomy_tube * df9.dc20,
  dcf.abscess_drain * df9.dc21,
  dcf.dc22 * df9.dc22,
  dcf.dc23 * df9.dc23,
  dcf.dc24 * df9.dc24,
  dcf.dc25 * df9.dc25,
  dcf.dc26 * df9.dc26,
  dcf.dc27 * df9.dc27,
  dcf.dc28 * df9.dc28,
  dcf.dc29 * df9.dc29,
  dcf.dc30 * df9.dc30,
  dcf.dc31 * df9.dc31,
  dcf.dc32 * df9.dc32,
  dcf.dc33 * df9.dc33,
  dcf.dc34 * df9.dc34,
  dcf.dc35 * df9.dc35,
  dcf.dc36 * df9.dc36,
  dcf.dc37 * df9.dc37,
  dcf.dc38 * df9.dc38,
  dcf.dc39 * df9.dc39,
  dcf.dc40 * df9.dc40,
  dcf.dc41 * df9.dc41) > 0 THEN 1 ELSE 0 END AS diversion_obs,
  CASE WHEN
  GREATEST(dcf.diagnosis_only * df10.dc1,
  dcf.survey_yes_to_er * df10.dc2,
  dcf.diversion_911 * df10.dc3,
  dcf.pos_snf * df10.dc4,
  dcf.pos_al * df10.dc5,
  dcf.referral * df10.dc6,
  dcf.after_hours * df10.dc7,
  dcf.abnormal_vitals * df10.dc8,
  dcf.confusion * df10.dc9,
  dcf.wheelchair_hb * df10.dc10,
  dcf.ekg * df10.dc11,
  dcf.nebulizer * df10.dc12,
  dcf.iv_fluids * df10.dc13,
  dcf.blood_tests * df10.dc14,
  dcf.catheter_placement * df10.dc15,
  dcf.laceration_repair * df10.dc16,
  dcf.epistaxis * df10.dc17,
  dcf.hernia_rp_reduction * df10.dc18,
  dcf.joint_reduction * df10.dc19,
  dcf.gastronomy_tube * df10.dc20,
  dcf.abscess_drain * df10.dc21,
  dcf.dc22 * df10.dc22,
  dcf.dc23 * df10.dc23,
  dcf.dc24 * df10.dc24,
  dcf.dc25 * df10.dc25,
  dcf.dc26 * df10.dc26,
  dcf.dc27 * df10.dc27,
  dcf.dc28 * df10.dc28,
  dcf.dc29 * df10.dc29,
  dcf.dc30 * df10.dc30,
  dcf.dc31 * df10.dc31,
  dcf.dc32 * df10.dc32,
  dcf.dc33 * df10.dc33,
  dcf.dc34 * df10.dc34,
  dcf.dc35 * df10.dc35,
  dcf.dc36 * df10.dc36,
  dcf.dc37 * df10.dc37,
  dcf.dc38 * df10.dc38,
  dcf.dc39 * df10.dc39,
  dcf.dc40 * df10.dc40,
  dcf.dc41 * df10.dc41,
  dcf.diagnosis_only * df11.dc1,
  dcf.survey_yes_to_er * df11.dc2,
  dcf.diversion_911 * df11.dc3,
  dcf.pos_snf * df11.dc4,
  dcf.pos_al * df11.dc5,
  dcf.referral * df11.dc6,
  dcf.after_hours * df11.dc7,
  dcf.abnormal_vitals * df11.dc8,
  dcf.confusion * df11.dc9,
  dcf.wheelchair_hb * df11.dc10,
  dcf.ekg * df11.dc11,
  dcf.nebulizer * df11.dc12,
  dcf.iv_fluids * df11.dc13,
  dcf.blood_tests * df11.dc14,
  dcf.catheter_placement * df11.dc15,
  dcf.laceration_repair * df11.dc16,
  dcf.epistaxis * df11.dc17,
  dcf.hernia_rp_reduction * df11.dc18,
  dcf.joint_reduction * df11.dc19,
  dcf.gastronomy_tube * df11.dc20,
  dcf.abscess_drain * df11.dc21,
  dcf.dc22 * df11.dc22,
  dcf.dc23 * df11.dc23,
  dcf.dc24 * df11.dc24,
  dcf.dc25 * df11.dc25,
  dcf.dc26 * df11.dc26,
  dcf.dc27 * df11.dc27,
  dcf.dc28 * df11.dc28,
  dcf.dc29 * df11.dc29,
  dcf.dc30 * df11.dc30,
  dcf.dc31 * df11.dc31,
  dcf.dc32 * df11.dc32,
  dcf.dc33 * df11.dc33,
  dcf.dc34 * df11.dc34,
  dcf.dc35 * df11.dc35,
  dcf.dc36 * df11.dc36,
  dcf.dc37 * df11.dc37,
  dcf.dc38 * df11.dc38,
  dcf.dc39 * df11.dc39,
  dcf.dc40 * df11.dc40,
  dcf.dc41 * df11.dc41,
  dcf.diagnosis_only * df12.dc1,
  dcf.survey_yes_to_er * df12.dc2,
  dcf.diversion_911 * df12.dc3,
  dcf.pos_snf * df12.dc4,
  dcf.pos_al * df12.dc5,
  dcf.referral * df12.dc6,
  dcf.after_hours * df12.dc7,
  dcf.abnormal_vitals * df12.dc8,
  dcf.confusion * df12.dc9,
  dcf.wheelchair_hb * df12.dc10,
  dcf.ekg * df12.dc11,
  dcf.nebulizer * df12.dc12,
  dcf.iv_fluids * df12.dc13,
  dcf.blood_tests * df12.dc14,
  dcf.catheter_placement * df12.dc15,
  dcf.laceration_repair * df12.dc16,
  dcf.epistaxis * df12.dc17,
  dcf.hernia_rp_reduction * df12.dc18,
  dcf.joint_reduction * df12.dc19,
  dcf.gastronomy_tube * df12.dc20,
  dcf.abscess_drain * df12.dc21,
  dcf.dc22 * df12.dc22,
  dcf.dc23 * df12.dc23,
  dcf.dc24 * df12.dc24,
  dcf.dc25 * df12.dc25,
  dcf.dc26 * df12.dc26,
  dcf.dc27 * df12.dc27,
  dcf.dc28 * df12.dc28,
  dcf.dc29 * df12.dc29,
  dcf.dc30 * df12.dc30,
  dcf.dc31 * df12.dc31,
  dcf.dc32 * df12.dc32,
  dcf.dc33 * df12.dc33,
  dcf.dc34 * df12.dc34,
  dcf.dc35 * df12.dc35,
  dcf.dc36 * df12.dc36,
  dcf.dc37 * df12.dc37,
  dcf.dc38 * df12.dc38,
  dcf.dc39 * df12.dc39,
  dcf.dc40 * df12.dc40,
  dcf.dc41 * df12.dc41) > 0 THEN 1 ELSE 0 END AS diversion_hosp,
  COALESCE(inspkg.er_diversion, chnpkg.er_diversion, der.diversion_savings_gross_amount, 2000) AS diversion_svgs_er,
  COALESCE(inspkg.nine_one_one_diversion, chnpkg.nine_one_one_diversion, d911.diversion_savings_gross_amount, 750) AS diversion_svgs_911,
  COALESCE(inspkg.observation_diversion, chnpkg.observation_diversion, dobs.diversion_savings_gross_amount, 4000) AS diversion_svgs_observation,
  COALESCE(inspkg.hospitalization_diversion, chnpkg.hospitalization_diversion, dhsp.diversion_savings_gross_amount, 12000) AS diversion_svgs_hospitalization,
  CASE WHEN d911.case_rate_plug_less_co_pay IS NULL THEN 150
  ELSE d911.case_rate_plug_less_co_pay
  END AS case_rate_plug_less_co_pay,
  CASE WHEN  d911.incremental_visit_cost IS NULL THEN 50
  ELSE d911.incremental_visit_cost
  END AS incremental_visit_cost,
  CASE WHEN ic.custom_insurance_grouping = '(CM)COMMERCIAL' THEN 0.05
  WHEN ic.custom_insurance_grouping = '(MA)MEDICARE ADVANTAGE' THEN 0.08
  WHEN ic.custom_insurance_grouping = '(MCARE)MEDICARE' THEN 0.08
  WHEN ic.custom_insurance_grouping = '(MMCD)MANAGED MEDICAID' THEN 0.07
  WHEN ic.custom_insurance_grouping = '(MAID)MEDICAID' THEN 0.05
  WHEN ic.custom_insurance_grouping = '(TC)TRICARE' THEN 0.05
  WHEN ic.custom_insurance_grouping = '(PSP)PATIENT SELF-PAY' THEN 0.05
  WHEN ic.custom_insurance_grouping = '(CB)CORPORATE BILLING' THEN 0.05
  ELSE 0.06
  END AS bounceback_multiplier,
  CASE WHEN ic.custom_insurance_grouping = '(CM)COMMERCIAL' THEN 0.05 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(MA)MEDICARE ADVANTAGE' THEN 0.08 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(MCARE)MEDICARE' THEN 0.08 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(MMCD)MANAGED MEDICAID' THEN 0.07 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(MAID)MEDICAID' THEN 0.05 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(TC)TRICARE' THEN 0.05 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(PSP)PATIENT SELF-PAY' THEN 0.05 * d911.case_rate_plug_less_co_pay
  WHEN ic.custom_insurance_grouping = '(CB)CORPORATE BILLING' THEN 0.05 * d911.case_rate_plug_less_co_pay
  ELSE 0.06 * d911.case_rate_plug_less_co_pay
  END AS bounceback_14_day_case_rate_adjustment

  --COALESCE(ins.hospitalization_diversion, ci.hospitalization_diversion, ds3.diversion_savings_gross_amount,12000) AS diversion_hosp_savings
  FROM looker_scratch.diversion_categories_by_care_request dcf
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} AS df
    ON dcf.diagnosis_code1 = df.diagnosis_code
  --ER Diversions
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df1
    ON dcf.diagnosis_code1 = df1.diagnosis_code AND df1.diversion_type_id = 1
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df2
    ON dcf.diagnosis_code2 = df2.diagnosis_code AND df2.diversion_type_id = 1
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df3
    ON dcf.diagnosis_code3 = df3.diagnosis_code AND df3.diversion_type_id = 1
  -- 911 diversions
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df4
    ON dcf.diagnosis_code1 = df4.diagnosis_code AND df4.diversion_type_id = 2
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df5
    ON dcf.diagnosis_code2 = df5.diagnosis_code AND df5.diversion_type_id = 2
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df6
    ON dcf.diagnosis_code3 = df6.diagnosis_code AND df6.diversion_type_id = 2
  --Observation Diversions
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df7
    ON dcf.diagnosis_code1 = df7.diagnosis_code AND df7.diversion_type_id = 4
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df8
    ON dcf.diagnosis_code2 = df8.diagnosis_code AND df8.diversion_type_id = 4
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df9
    ON dcf.diagnosis_code3 = df9.diagnosis_code AND df9.diversion_type_id = 4
  --Hospitalization Diversions
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df10
    ON dcf.diagnosis_code1 = df10.diagnosis_code AND df10.diversion_type_id = 3
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df11
    ON dcf.diagnosis_code2 = df11.diagnosis_code AND df11.diversion_type_id = 3
  LEFT JOIN ${diversion_flat.SQL_TABLE_NAME} df12
    ON dcf.diagnosis_code3 = df12.diagnosis_code AND df12.diversion_type_id = 3

LEFT JOIN ${insurance_coalese.SQL_TABLE_NAME} ic
    ON dcf.care_request_id = ic.care_request_id

  LEFT JOIN inspkg
    ON ic.package_id_coalese = inspkg.package_id
  LEFT JOIN public.care_requests cr
    ON dcf.care_request_id = cr.id
  LEFT JOIN chnpkg
    ON cr.channel_item_id = chnpkg.channel_item_id
  LEFT JOIN looker_scratch.diversion_savings_gross_by_insurance_group der
    ON ic.custom_insurance_grouping = der.custom_insurance_grouping AND der.diversion_type_id = 1
  LEFT JOIN looker_scratch.diversion_savings_gross_by_insurance_group d911
    ON ic.custom_insurance_grouping = d911.custom_insurance_grouping AND d911.diversion_type_id = 2
  LEFT JOIN looker_scratch.diversion_savings_gross_by_insurance_group dobs
    ON ic.custom_insurance_grouping = dobs.custom_insurance_grouping AND dobs.diversion_type_id = 4
  LEFT JOIN looker_scratch.diversion_savings_gross_by_insurance_group dhsp
    ON ic.custom_insurance_grouping = dhsp.custom_insurance_grouping AND dhsp.diversion_type_id = 3;;

    sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
    indexes: ["care_request_id", "insurance_package_id"]

  }

  dimension: care_request_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.care_request_id ;;
  }
  # dimension: diversion_911 {
  #   type: yesno
  #   sql: ${TABLE}.diversion_911 = 1 ;;
  # }
  dimension: adjust_diversion_911 {
    type:  string
    hidden: yes
    sql: CASE
          WHEN  ${care_request_flat.escalated_on_scene} THEN 'No'
          WHEN ${care_requests.billable_est_excluding_bridge_care_and_dh_followups}  THEN 'No'
          WHEN ${TABLE}.diversion_911::INT = 1 THEN 'Yes'
          ELSE NULL
          END;;
  }
  dimension: diversion_911 {
    type: yesno
    sql: ${adjust_diversion_911} = 'Yes' ;;
  }
  measure: count_911_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_911
      value: "Yes"
    }
  }
  dimension: savings_911 {
    type: number
    sql: ${TABLE}.diversion_svgs_911 ;;
  }
  measure: diversion_savings_911 {
    type: sum_distinct
    sql: ${savings_911} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    filters: {
      field: diversion_911
      value: "Yes"
    }
  }
  # dimension: diversion_er {
  #   type: yesno
  #   sql: ${TABLE}.diversion_er::int = 1;;
  #   # AND NOT ${diversion_hosp} AND NOT ${diversion_observation};;
  # }
  dimension: adjust_diversion_er {
    type:  string
    hidden: no
    sql: CASE
            WHEN  ${care_request_flat.escalated_on_scene} THEN 'No'
            WHEN ${care_requests.billable_est_excluding_bridge_care_and_dh_followups}  THEN 'No'
            WHEN ${TABLE}.diversion_er::INT = 1 THEN 'Yes'
            ELSE NULL
            END;;
  }

  dimension: diversion_er {
    type: yesno
    sql: ${adjust_diversion_er} = 'Yes';;
    # AND NOT ${diversion_hosp} AND NOT ${diversion_observation};;
  }
  measure: count_er_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_er
      value: "Yes"
    }
  }

  dimension: savings_er {
    type: number
    sql:${TABLE}.diversion_svgs_er;;
  }
  measure: diversion_savings_er {
    type: sum_distinct
    sql: ${savings_er} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    filters: {
      field: diversion_er
      value: "Yes"
    }
  }
  # dimension: diversion_observation {
  #   type: yesno
  #   sql: ${TABLE}.diversion_obs = 1 AND NOT ${diversion_hosp};;
  # }

  dimension: adjust_diversion_observation {
    type:  string
    hidden: yes
    sql: CASE
          WHEN  ${care_request_flat.escalated_on_scene} THEN 'No'
          WHEN ${care_requests.billable_est_excluding_bridge_care_and_dh_followups}  THEN 'No'
          WHEN ${TABLE}.diversion_obs::INT = 1 THEN 'Yes'
          ELSE NULL
          END;;
  }

  dimension: diversion_observation {
    type: yesno
    sql: ${adjust_diversion_observation} = 'Yes';;
  }
  measure: count_observation_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_observation
      value: "Yes"
    }
  }
  dimension: savings_observation {
    type: number
    sql: ${TABLE}.diversion_svgs_observation ;;
  }
  measure: diversion_savings_obs {
    type: sum_distinct
    sql: ${savings_observation} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    filters: {
      field: diversion_observation
      value: "Yes"
    }
  }
  # dimension: diversion_hosp {
  #   type: yesno
  #   sql: ${TABLE}.diversion_hosp = 1;;
  # }

  dimension: adjust_diversion_hosp {
    type:  string
    hidden: yes
    sql: CASE
          WHEN  ${care_request_flat.escalated_on_scene} THEN 'No'
          WHEN ${care_requests.billable_est_excluding_bridge_care_and_dh_followups}  THEN 'No'
          WHEN ${TABLE}.diversion_hosp::INT = 1 THEN 'Yes'
          ELSE NULL
          END;;
  }

  dimension: diversion_hosp {
    type: yesno
    sql: ${adjust_diversion_hosp} = 'Yes';;
  }
  measure: count_hospitalization_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_hosp
      value: "Yes"
    }
  }
  dimension: savings_hospitalization {
    type: number
    sql: ${TABLE}.diversion_svgs_hospitalization ;;
  }
  measure: diversion_savings_hospitalization {
    type: sum_distinct
    sql: ${savings_hospitalization} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    filters: {
      field: diversion_hosp
      value: "Yes"
    }
  }
  dimension: case_rate_less_copay {
    type: number
    sql: ${TABLE}.case_rate_plug_less_co_pay;;
  }
  measure: sum_case_rate {
    type: sum_distinct
    sql: ${case_rate_less_copay} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
  }
  dimension: incremental_visit_cost {
    type: number
    sql: ${TABLE}.incremental_visit_cost ;;
  }
  measure: sum_incremental_visit_cost {
    type: sum_distinct
    sql: ${incremental_visit_cost} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
  }
  dimension: diversion {
    description: "A flag indicating that any diversion criteria was met"
    type: yesno
    sql: ${diversion_911} OR ${diversion_er} OR ${diversion_observation} OR ${diversion_hosp} ;;
  }
  measure: count_any_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion
      value: "Yes"
    }
  }

  dimension: diversion_or_escalated_on_scene {
    description: "A flag indicating that any diversion criteria was met"
    type: yesno
    sql: ${diversion} OR  ${care_request_flat.escalated_on_scene};;
  }
  measure: count_high_acuity_visits_cost_saving {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_or_escalated_on_scene
      value: "Yes"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
    # filters: {
    #   field: care_requests.post_acute_follow_up
    #   value: "No"
    # }
    # filters: {
    #   field: care_requests.DHFU_follow_up
    #   value: "No"
    # }
  }
  measure: sum_case_rate_high_acuity {
    type: sum_distinct
    sql: ${case_rate_less_copay} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: diversion_or_escalated_on_scene
      value: "Yes"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
    # filters: {
    #   field: care_requests.post_acute_follow_up
    #   value: "No"
    # }
    # filters: {
    #   field: care_requests.DHFU_follow_up
    #   value: "No"
    # }
  }
  measure: count_low_acuity_visits_cost_saving {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_or_escalated_on_scene
      value: "No"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
    # filters: {
    #   field: care_requests.post_acute_follow_up
    #   value: "No"
    # }
    # filters: {
    #   field: care_requests.DHFU_follow_up
    #   value: "No"
    # }
  }
  measure: sum_incremental_visit_cost_low_acuity {
    type: sum_distinct
    sql: ${incremental_visit_cost} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: diversion_or_escalated_on_scene
      value: "No"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
    # filters: {
    #   field: care_requests.post_acute_follow_up
    #   value: "No"
    # }
    # filters: {
    #   field: care_requests.DHFU_follow_up
    #   value: "No"
    # }
  }
  dimension: bounceback_14_day_case_rate_adjustment {
    type: number
    sql: ${TABLE}.bounceback_14_day_case_rate_adjustment ;;
  }
  dimension: bounceback_multiplier {
    type: number
    sql: ${TABLE}.bounceback_multiplier ;;
  }
  measure: sum_bounceback_14_day_case_rate_adjustment {
    type: sum_distinct
    sql: ${bounceback_14_day_case_rate_adjustment} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }
  measure: count_bounceback_14_day_calc {
    type: sum_distinct
    sql: ${bounceback_multiplier} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }
#   dimension: 14_day_bounceback_case_rate_calculated {
#     type: number
#     sql: ${care_requests.count_billable_est}*${bounceback_multiplier} ;;
#   }
#
#   measure: sum_14_day_bounceback_case_rate_calculated {
#     type: sum_distinct
#     sql: ${14_day_bounceback_case_rate_calculated} ;;
#     sql_distinct_key: ${care_request_id} ;;
#   }


  }
