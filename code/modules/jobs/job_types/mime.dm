/datum/job/mime
	title = "Mime"
	description = "..."
	flag = MIME
	orbit_icon = "comment-slash"
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/mime

	alt_titles = list("Mute Entertainer", "Silent Jokester", "Pantomimist")

	added_access = list()
	base_access = list(ACCESS_THEATRE)
	paycheck = PAYCHECK_MINIMAL
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_MIME
	minimal_character_age = 18 //Mime?? Might increase this a LOT depending on how mime lore turns out

	mail_goodies = list(
		/obj/item/reagent_containers/food/snacks/baguette = 15,
		/obj/item/reagent_containers/food/snacks/store/cheesewheel = 10,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 10,
		/obj/item/book/mimery = 1,
	)

	smells_like = "complete nothingness"

/datum/job/mime/after_spawn(mob/living/carbon/human/H, mob/M)
	H.apply_pref_name("mime", M.client)

/datum/outfit/job/mime
	name = "Mime"
	jobtype = /datum/job/mime

	pda_type = /obj/item/modular_computer/tablet/pda/preset/basic/mime

	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/mime
	uniform_skirt = /obj/item/clothing/under/rank/mime/skirt
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/frenchberet
	suit = /obj/item/clothing/suit/suspenders
	backpack_contents = list(
	/obj/item/book/mimery=1,
	/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing=1,
	/obj/item/stamp/mime = 1)

	backpack = /obj/item/storage/backpack/mime
	satchel = /obj/item/storage/backpack/mime

	chameleon_extras = /obj/item/stamp/mime


/datum/outfit/job/mime/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak(null))
		H.mind.miming = 1

/obj/item/book/mimery
	name = "Guide to Dank Mimery"
	desc = "A primer on basic pantomime."
	icon_state ="bookmime"

/obj/item/book/mimery/attack_self(mob/user,)
	user.set_machine(src)
	var/dat = "<HTML><HEAD><meta charset='UTF-8'></HEAD><BODY>"
	dat += "<B>Guide to Dank Mimery</B><BR>"
	dat += "Teaches one of three classic pantomime routines, allowing a practiced mime to conjure invisible objects into corporeal existence.<BR>"
	dat += "Once you have mastered your routine, this book will have no more to say to you.<BR>"
	dat += "<HR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_wall=1'>Invisible Wall</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_chair=1'>Invisible Chair</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_box=1'>Invisible Box</A><BR>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=book")

/obj/item/book/mimery/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || src.loc != usr)
		return
	if (!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.is_holding(src) && H.mind)
		H.set_machine(src)
		if (href_list["invisible_wall"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		if (href_list["invisible_chair"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair(null))
		if (href_list["invisible_box"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_box(null))
	to_chat(usr, span_notice("The book disappears into thin air."))
	qdel(src)
