% "In all patients with a recent or remote history of MI or ACS and reduced EF, 
% evidence-based beta blockers should be used to reduce mortality."

recommendation(beta_blockers, class_1):- accf_stage(b),
	history_of_mi_or_acs, measurement(lvef, Data),
	reduced_ef(Data), not contraindication(beta_blockers).

% 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "Digoxin can be beneficial in patients with HFrEF, unless 
% contraindicated, to decrease hospitalizations for HF."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recommendation(digoxin, class_2a) :- 
	not contraindication(digoxin),
	accf_stage(c), hf_with_reduced_ef.
contraindication(digoxin) :- 
	evidence(atrioventricular_block).

% 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "In patients with structural cardiac abnormalities, 
% including LV hypertrophy, in the absence of a history of MI or ACS, 
% blood pressure should be controlled in accordance with clinical
% practice guidelines for hypertension to prevent symptomatic HF."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recommendation(blood_pressure_control, class_1):-
	accf_stage(b), 
	diagnosis(structural_cardiac_abnormalities),
	not contraindication(blood_pressure_control).
contraindication(blood_pressure_control):- not -history(mi).
contraindication(blood_pressure_control):- not -history(acs).

% 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "Anticoagulation is not recommended in patients with 
% chronic HFrEF without AF, a prior thromboembolic event, 
% or a cardioembolic source."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

contraindication(anticoagulation) :- 
	not cardioembolic_source,
	not diagnosis(af), 
	not history(thromboembolism),
	hf_with_reduced_ef.

% 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "ARBs are recommended in patients with HFrEF with current 
% or prior symptoms who are ACE inhibitor intolerant, unless 
% contraindicated, to reduce morbidity and mortality."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recommendation(ace_inhibitors, class_1) :-
	not contraindication(ace_inhibitors),
	accf_stage(c), hf_with_reduced_ef.
recommendation(arbs, class_1) :- 
	contraindication(ace_inhibitors),
	not contraindication(arbs),
	not taboo_choice(arbs),
	accf_stage(c), 
	hf_with_reduced_ef.

% 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "Diuretics should generally be combined with an ACE inhib-
% itor, beta blocker, and aldosterone antagonist. Few patients with HF 
% will be able to maintain target weight without the use of diuretics."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recommendation(ace_inhibitors, class_1) :- 
	accf_stage(c),
	not skip_concomitant_choice(ace_inhibitors),
	not contraindication(ace_inhibitors), 
	hf_with_reduced_ef.
skip_concomitant_treatment(ace_inhibitors) :-
	hf_with_reduced_ef, 
	not recommendation(diuretics, class_1),
	not contraindication(diuretics).
recommendation(diuretics, class_1) :-
	hf_with_reduced_ef, 
	not contraindication(diuretics),
	recommendation(ace_inhibitors, class_1).

% 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "In patients with a current or recent history of fluid 
% retention, beta blockers should not be prescribed without diuretics."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recommendation(beta_blockers, class_1) :-
	not skip_concomitant_choice(beta_blockers),
	not absent_indispensable_choice(beta_blockers),
	not contraindication(beta_blockers), 
	accf_stage(c), 
	hf_with_reduced_ef.
absent_indispensable_choice(beta_blockers) :-
	not recommendation(diuretics, class_1), 
	hf_with_reduced_ef,
	accf_stage(c), 
	current_or_recent_history_of_fluid_retention.
recommendation(diuretics, class_1) :-
	recommendation(beta_blockers, class_1),
	not contraindication(diuretics), 
	accf_stage(c), 
	hf_with_reduced_ef,
	current_or_recent_history_of_fluid_retention.

% 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guideline: "Routine combined use of an ACE inhibitor, ARB, and 
% aldosterone antagonist is potentially harmful for patients with HFrEF."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

taboo_choice(ace_inhibitors) :- 
	hf_with_reduced_ef,
	recommendation(arbs, class_1),
	recommendation(aldosterone_antagonist, class_1).
taboo_choice(arbs) :- 
	hf_with_reduced_ef,
	recommendation(ace_inhibitors, class_1),
	recommendation(aldosterone_antagonist, class_1).
taboo_choice(aldosterone_antagonist) :- 
	hf_with_reduced_ef,
	recommendation(arbs, class_1), 
	recommendation(ace_inhibitors, class_1).
recommendation(ace_inhibitors, class_1) :- 
	accf_stage(c),
	hf_with_reduced_ef, 
	not skip_concomitant_choice(ace_inhibitors),
	not taboo_choice(ace_inhibitors), 
	not contraindication(ace_inhibitors).
recommendation(arbs, class_1) :- 
	contraindication(ace_inhibitors),
	not contraindication(arbs), 
	not taboo_choice(arbs),
	accf_stage(c), 
	hf_with_reduced_ef.
recommendation(aldosterone_antagonist, class_1) :-
	conditions_for_aldosterone_antagonist_class_1,
	not skip_concomitant_choice(aldosterone_antagonist),
	not contraindication(aldosterone_antagonist),
	not taboo_choice(aldosterone_antagonist).


% Patient info

% Doctor's Assesement
accf_stage(c).
nyha_class(3).
expectation_of_survival(3).

% Demographics of the patient
gender(female).
age(78).

% Measurements from the Lab
hf_with_reduced_ef.
measurement(creatinine, 1.8).
measurement(potassium, 4.9).
measurement(lvef, 0.35).
measurement(lbbb, 180).
measurement(sinus_rhythm).

% History of the Patient
diagnosis(myocardial_ischemia).
diagnosis(atrial_fibrillation).
diagnosis(coronary_artery_disease).
diagonosis(hypertension).
evidence(ischemic_etiology_of_hf).
evidence(sleep_apnea).
evidence(fluid_retention).
history(mi, recent).
history(stroke).
history(cardiovascular_hospitalization).
post_mi(40).

#compute 3 {recommendation(Treatment,Class)}.

