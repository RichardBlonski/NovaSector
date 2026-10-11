/datum/addiction/nicotine/proc/trigger_random_side_effect(mob/living/carbon/affected_carbon, seconds_per_tick, strength = 1)
	switch(rand(1, 4))
		if(1)
			if(!HAS_TRAIT(affected_carbon, TRAIT_NOHUNGER))
				affected_carbon.adjust_nutrition(-5 * seconds_per_tick)
		if(2)
			to_chat(affected_carbon, span_warning("Your head hurts."))
			affected_carbon.adjust_stamina_loss(25 * seconds_per_tick)
		if(3)
			if(strength >= 2)
				to_chat(affected_carbon, span_warning("You feel a little dizzy."))
				affected_carbon.set_dizzy(strength * 6 SECONDS)
		if(4)
			if(strength >= 2)
				to_chat(affected_carbon, span_warning("You feel tired."))
				affected_carbon.adjust_stamina_loss(37.5 * seconds_per_tick)

/datum/addiction/nicotine/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[1]]"))

/datum/addiction/nicotine/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[2]]"))

/datum/addiction/nicotine/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[3]]"))

/datum/addiction/nicotine/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.3, seconds_per_tick))
		to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[1]]"))

/datum/addiction/nicotine/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.5, seconds_per_tick))
		trigger_random_side_effect(affected_carbon, seconds_per_tick, 1)
	if(SPT_PROB(0.5, seconds_per_tick))
		to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[2]]"))

/datum/addiction/nicotine/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(SPT_PROB(0.7, seconds_per_tick))
		trigger_random_side_effect(affected_carbon, seconds_per_tick, 2)
	if(SPT_PROB(0.7, seconds_per_tick))
		to_chat(affected_carbon, span_danger("[withdrawal_stage_messages[3]]"))

/datum/addiction/alcohol
	addiction_gain_threshold = 900
	addiction_loss_threshold = 600

/datum/addiction/alcohol/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(30 SECONDS * seconds_per_tick)
	affected_carbon.set_hallucinations_if_lower(10 SECONDS)
	// Drunk people are spared seizures unless they are in really bad shape
	if(affected_carbon.get_drunk_amount() > 30)
		return
	if(SPT_PROB(4, seconds_per_tick) && !HAS_TRAIT(affected_carbon, TRAIT_ANTICONVULSANT))
		affected_carbon.apply_status_effect(/datum/status_effect/seizure)
