import 'dart:convert';
import 'dart:io';

void main() async {
  final rules = <Map<String, dynamic>>[];
  
  void addRule(String id, String topic, String subtopic, String summary, {String? details, String? exceptions, String? page}) {
    rules.add({
      "ruleId": id,
      "stateId": "ca",
      "topic": topic,
      "subtopic": subtopic,
      "ruleSummary": summary,
      "details": details,
      "exceptions": exceptions,
      "sourceId": "ca_dmv_handbook",
      "section": topic,
      "page": page,
      "sourceVersion": "Current",
      "contentVersion": "v1.1",
      "effectiveDate": "2024-01-01",
      "lastVerified": 1725015000,
      "status": "verified"
    });
  }

  // --- EXISTING 20 RULES (Retro-fitted with new fields) ---
  addRule("ca_rule_speed_limit_school", "Speed Limits", "School Zones", "The speed limit is 25 mph within 500 feet of a school while children are outside or crossing the street.", details: "Some school zones may have speed limits as low as 15 mph.", exceptions: "If the school grounds have no fence and children are outside, never drive faster than 25 mph.");
  addRule("ca_rule_speed_limit_blind_intersection", "Speed Limits", "Intersections", "The speed limit for a blind intersection is 15 mph.", details: "An intersection is 'blind' if there are no stop signs at any corner and you cannot see 100 feet in either direction before crossing.");
  addRule("ca_rule_speed_limit_alley", "Speed Limits", "Alleys", "The speed limit in any alley is 15 mph.");
  addRule("ca_rule_speed_limit_railroad", "Speed Limits", "Railroad Crossings", "The speed limit is 15 mph within 100 feet of a railroad crossing where you cannot see the tracks for 400 feet in both directions.", details: "You may drive faster if the crossing is controlled by gates, a warning signal, or a flag man.");
  addRule("ca_rule_right_of_way_pedestrians", "Right of Way", "Pedestrians", "Pedestrians have the right-of-way in marked or unmarked crosswalks.", exceptions: "Pedestrians must not suddenly leave a curb and walk or run into the path of a vehicle that is so close as to constitute an immediate hazard.");
  addRule("ca_rule_parking_fire_hydrant", "Parking", "Illegal Parking", "It is illegal to park within 15 feet of a fire hydrant or a fire station driveway.");
  addRule("ca_rule_parking_curb_colors_red", "Parking", "Curb Colors", "A red curb means no stopping, standing, or parking.", exceptions: "Transit buses are exempt at designated bus stops.");
  addRule("ca_rule_blood_alcohol_limit_adult", "Alcohol and Drugs", "BAC Limits", "It is illegal for a person 21 years of age or older to drive with a blood alcohol concentration (BAC) of 0.08% or higher.");
  addRule("ca_rule_blood_alcohol_limit_minor", "Alcohol and Drugs", "BAC Limits", "It is illegal for a person under 21 years of age to drive with a blood alcohol concentration (BAC) of 0.01% or higher.");
  addRule("ca_rule_blood_alcohol_limit_commercial", "Alcohol and Drugs", "BAC Limits", "It is illegal for a person to drive a commercial vehicle with a blood alcohol concentration (BAC) of 0.04% or higher.");
  addRule("ca_rule_passing_school_bus", "Traffic Laws", "School Buses", "You must stop from either direction until children are safely across the street and the red lights on the school bus stop flashing.", exceptions: "You do not need to stop if the school bus is on the other side of a divided or multilane highway.");
  addRule("ca_rule_lane_changes_signal", "Lane Changes", "Signaling", "You should signal at least 100 feet before you turn.", details: "On a freeway, you should signal for at least 5 seconds before changing lanes.");
  addRule("ca_rule_headlights_usage", "Vehicle Equipment", "Headlights", "You must use your headlights 30 minutes after sunset and leave them on until 30 minutes before sunrise.");
  addRule("ca_rule_headlights_wipers", "Vehicle Equipment", "Headlights", "You must turn on your low-beam headlights if weather conditions require you to use your windshield wipers.");
  addRule("ca_rule_cell_phone_minor", "Distracted Driving", "Cell Phones", "It is against the law for a minor to use a cell phone or electronic wireless communications device while driving.", exceptions: "Exceptions exist for calling emergency services (911) in an emergency situation.");
  addRule("ca_rule_following_distance", "Safe Driving", "Following Distance", "Use the '3-second rule' to avoid tailgating.", exceptions: "Allow a 4-second or more following distance when tailgated, driving on slippery roads, or following motorcyclists/bicyclists on wet or icy roads.");
  addRule("ca_rule_turning_steering_wheel", "Vehicle Control", "Steering", "Use the hand-to-hand steering method (push/pull) for most turning maneuvers.", exceptions: "Hand-over-hand steering is recommended when turning at low speeds, parking, or recovering from a skid.");
  addRule("ca_rule_right_of_way_t_intersection", "Right of Way", "Intersections", "At a T-intersection without STOP or YIELD signs, vehicles on the through road have the right-of-way.");
  addRule("ca_rule_right_of_way_mountain", "Right of Way", "Mountain Roads", "When two vehicles meet on a steep narrow road where neither can pass, the vehicle facing downhill must yield the right-of-way by backing up.");
  addRule("ca_rule_u_turn_residential", "Turns", "U-Turns", "You may make a U-turn in a residential district if there are no vehicles approaching you within 200 feet.", exceptions: "Never make a U-turn in a business district, unless at an intersection or where a sign explicitly permits it.");

  // --- NEW RULES TO REACH ~100 ---
  
  // High Priority: Traffic Laws / Right of Way / Intersections
  addRule("ca_rule_four_way_stop", "Right of Way", "Intersections", "At a four-way stop, the first vehicle to arrive has the right-of-way.", details: "If two vehicles arrive at the same time, the vehicle on the left must yield to the vehicle on the right.");
  addRule("ca_rule_roundabout_direction", "Intersections", "Roundabouts", "Traffic travels in a counter-clockwise direction around a roundabout.", details: "Yield to traffic already in the roundabout. Enter heading to the right.");
  addRule("ca_rule_roundabout_yield", "Intersections", "Roundabouts", "You must yield to all traffic, including bicyclists and pedestrians, already in the roundabout.");
  addRule("ca_rule_passing_bicycles", "Right of Way", "Bicycles", "When passing a bicyclist, you must leave at least three feet of space between your vehicle and the bicycle.", exceptions: "If 3 feet is not possible, you must slow down and pass only when safe to do so.");
  addRule("ca_rule_yielding_to_transit", "Right of Way", "Transit Buses", "You must yield the right-of-way to a transit bus signaling to re-enter traffic after stopping at a bus stop.");
  addRule("ca_rule_yielding_emergency_vehicles", "Right of Way", "Emergency Vehicles", "You must yield the right-of-way to any police vehicle, fire engine, or ambulance using a siren and red lights.", details: "Drive to the right edge of the road and stop until the emergency vehicle has passed.", exceptions: "Do not stop in an intersection.");
  addRule("ca_rule_move_over_law", "Traffic Laws", "Move Over Law", "When approaching a stationary emergency vehicle or tow truck with flashing lights, you must move over a lane or slow down.", exceptions: "If you cannot move over safely, slow down to a reasonable speed.");
  addRule("ca_rule_solid_yellow_lines", "Pavement Markings", "Yellow Lines", "Two solid yellow lines mean no passing.", exceptions: "You may cross two solid yellow lines to turn left into a driveway or private road, or make a permitted U-turn.");
  addRule("ca_rule_broken_yellow_lines", "Pavement Markings", "Yellow Lines", "A broken yellow line means you may pass if the broken line is next to your driving lane.");
  addRule("ca_rule_double_solid_white_lines", "Pavement Markings", "White Lines", "Double solid white lines indicate a lane barrier between a regular use and a preferential use lane, such as a carpool/HOV lane. Never cross them.");
  addRule("ca_rule_center_left_turn_lane", "Lane Changes", "Center Lanes", "A center left turn lane is marked by two solid yellow lines on the outside and two broken yellow lines on the inside. You may only drive for 200 feet in this lane.", details: "Use it to begin or end a left turn or U-turn.");
  addRule("ca_rule_turnout_areas", "Traffic Laws", "Turnouts", "You must use a turnout area to let other vehicles pass if you are driving slowly on a two-lane highway or road where passing is unsafe, and there are 5 or more vehicles following you.");
  addRule("ca_rule_bike_lane_parking", "Parking", "Bike Lanes", "You may park in a bicycle lane if your vehicle does not block a bicyclist and there is no 'No Parking' sign posted.");
  addRule("ca_rule_bike_lane_turning", "Turns", "Bike Lanes", "When making a right turn, you must enter the bicycle lane no more than 200 feet before the corner.");
  addRule("ca_rule_yielding_blind_pedestrians", "Right of Way", "Pedestrians", "You must yield to a blind pedestrian crossing the street with a white cane or a guide dog at all times.");
  addRule("ca_rule_yielding_at_crosswalks", "Right of Way", "Pedestrians", "Do not pass a vehicle stopped at a crosswalk. A pedestrian you cannot see may be crossing the street.");
  
  // Speed Limits (High Priority)
  addRule("ca_rule_speed_limit_max_freeway", "Speed Limits", "Freeways", "The maximum speed limit on most California highways is 65 mph.", exceptions: "You may drive 70 mph where posted.");
  addRule("ca_rule_speed_limit_two_lane", "Speed Limits", "Highways", "The maximum speed limit on a two-lane undivided highway is 55 mph unless otherwise posted.");
  addRule("ca_rule_speed_limit_business", "Speed Limits", "Business Districts", "The speed limit in business or residential districts is 25 mph unless otherwise posted.");
  addRule("ca_rule_speed_limit_animals", "Speed Limits", "Animals", "If you see a sign with a picture of an animal, slow down and be prepared to stop. You must obey a person in charge of animals.");
  addRule("ca_rule_speed_law_basic", "Speed Limits", "Basic Speed Law", "California's Basic Speed Law says you may never drive faster than is safe for current conditions.");
  
  // Safe Driving / Defensive Driving (Medium Priority)
  addRule("ca_rule_scanning_ahead", "Defensive Driving", "Scanning", "You should scan the road 10-15 seconds ahead of your vehicle so you can see hazards early.");
  addRule("ca_rule_check_mirrors_frequently", "Defensive Driving", "Scanning", "Check your rearview mirrors every 2 to 5 seconds so you know what traffic is doing behind you.");
  addRule("ca_rule_blind_spots", "Defensive Driving", "Blind Spots", "Always look over your shoulder to check your blind spots before you change lanes, turn, or merge.");
  addRule("ca_rule_tailgating_large_vehicles", "Safe Driving", "Following Distance", "If you are tailgating a large truck, you cannot see around it, and the truck driver cannot see you in their rearview mirrors.");
  addRule("ca_rule_stopping_behind_trucks", "Safe Driving", "Intersections", "When stopping behind a large truck at an intersection, leave extra space in case the truck rolls backward when starting.");
  addRule("ca_rule_wet_roads", "Safe Driving", "Weather", "Go 5 to 10 mph slower on wet roads.", details: "If it is raining hard and you cannot see more than 100 feet ahead, you cannot safely drive faster than 30 mph.");
  addRule("ca_rule_packed_snow", "Safe Driving", "Weather", "Cut your speed in half when driving on packed snow.");
  addRule("ca_rule_ice", "Safe Driving", "Weather", "Slow to a crawl on ice.");
  addRule("ca_rule_hydroplaning", "Safe Driving", "Weather", "In heavy rain at speeds of 50 mph or more, your tires can lose all contact with the road and your vehicle will be riding on water (hydroplaning).", details: "If this happens, slow down gradually. Do not apply the brakes.");
  addRule("ca_rule_high_beams_fog", "Safe Driving", "Weather", "Use low-beam headlights in fog, rain, or snow.", exceptions: "High beams will reflect back and cause glare.");
  addRule("ca_rule_high_beams_distance", "Vehicle Equipment", "Headlights", "You must dim your high-beam headlights to low beams within 500 feet of a vehicle coming toward you or within 300 feet of a vehicle you are following.");
  
  // Parking (Medium Priority)
  addRule("ca_rule_parking_curb_colors_white", "Parking", "Curb Colors", "A white curb means stop only long enough to pick up or drop off passengers or mail.");
  addRule("ca_rule_parking_curb_colors_green", "Parking", "Curb Colors", "A green curb means park for a limited time. Look for a posted sign next to the green zone for time limits.");
  addRule("ca_rule_parking_curb_colors_yellow", "Parking", "Curb Colors", "A yellow curb means stop no longer than the time posted to load or unload passengers or freight.", exceptions: "Drivers of noncommercial vehicles are usually required to stay with the vehicle.");
  addRule("ca_rule_parking_curb_colors_blue", "Parking", "Curb Colors", "A blue curb means parking is permitted only for a disabled person or driver of a disabled person who displays a placard or special license plate.");
  addRule("ca_rule_parking_downhill", "Parking", "Hills", "When parking downhill on a street with a curb, turn your front wheels into the curb or toward the side of the road.", details: "Set the parking brake.");
  addRule("ca_rule_parking_uphill", "Parking", "Hills", "When parking uphill on a street with a curb, turn your front wheels away from the curb and let your vehicle roll back a few inches. The wheel should gently touch the curb.");
  addRule("ca_rule_parking_no_curb", "Parking", "Hills", "When parking headed either uphill or downhill when there is no curb, turn the wheels so the vehicle will roll away from the center of the road if the brakes fail.");
  addRule("ca_rule_parking_distance_from_curb", "Parking", "Rules", "Your vehicle must be parked parallel to the street and within 18 inches of the curb.");
  addRule("ca_rule_parking_crosswalk", "Parking", "Illegal Parking", "It is illegal to park on a marked or unmarked crosswalk, sidewalk, partially blocking a sidewalk, or in front of a driveway.");
  addRule("ca_rule_parking_railroad", "Parking", "Illegal Parking", "It is illegal to park within 7.5 feet of a railroad track.");
  
  // Freeway Driving / Merging (High Priority)
  addRule("ca_rule_merging_freeway", "Lane Changes", "Merging", "When entering the freeway, you should enter at or near the speed of traffic.", exceptions: "Do not stop before merging into freeway traffic unless it is absolutely necessary.");
  addRule("ca_rule_merging_space", "Lane Changes", "Merging", "Any time you merge with other traffic, you need a gap of at least 4 seconds.");
  addRule("ca_rule_exiting_freeway", "Lane Changes", "Exiting", "When exiting a freeway, signal your intention for approximately 5 seconds before you reach the exit.");
  addRule("ca_rule_passing_on_right", "Lane Changes", "Passing", "You may pass on the right only when an open highway is clearly marked for two or more lanes of travel in your direction.", exceptions: "Never drive off the paved or main-traveled portion of the road or on the shoulder to pass.");
  
  // Alcohol and Drugs (High Priority)
  addRule("ca_rule_open_container", "Alcohol and Drugs", "Open Containers", "It is illegal to drink any amount of alcohol, or smoke or ingest any cannabis product while driving or riding as a passenger in a motor vehicle.", exceptions: "Containers of alcohol must be full, sealed, and unopened. Otherwise they must be kept in the trunk.");
  addRule("ca_rule_dui_conviction_time", "Alcohol and Drugs", "DUI Conviction", "A DUI conviction remains on your driving record for 10 years.");
  addRule("ca_rule_implied_consent", "Alcohol and Drugs", "Testing", "By driving in California, you consent to have your breath, blood, or urine tested if you are arrested for driving under the influence (Implied Consent Law).");
  addRule("ca_rule_prescription_drugs", "Alcohol and Drugs", "Drugs", "It is illegal to drive after taking any medication that impairs your ability to drive safely.", details: "This includes prescription and over-the-counter medications.");
  
  // Distracted Driving / Mobile Phones (Medium Priority)
  addRule("ca_rule_cell_phone_adult", "Distracted Driving", "Cell Phones", "Drivers 18 and older may use a cell phone only if it is hands-free, such as Bluetooth or a mounted device.", details: "The device must be mounted on the windshield, dashboard, or center console, and only require a single swipe or tap to use.");
  addRule("ca_rule_earplugs", "Distracted Driving", "Headphones", "It is illegal to wear a headset or earplugs in both ears while driving.", exceptions: "Persons operating authorized emergency vehicles or special construction equipment.");
  
  // Seat Belts and Child Restraints (Medium Priority)
  addRule("ca_rule_seat_belt_law", "Seat Belts", "General", "You and all passengers must wear a seat belt or you may be cited.", details: "If your passenger is under 16 years old and not wearing a seat belt, you will be cited.");
  addRule("ca_rule_child_restraint_age_8", "Child Restraints", "Ages", "Children under 8 years old, or who are less than 4 feet 9 inches tall, must be properly secured in a federally-approved child passenger restraint system in the rear seat.");
  addRule("ca_rule_child_restraint_age_2", "Child Restraints", "Ages", "Children under 2 years old must be secured in a rear-facing child passenger restraint system unless the child weighs 40 pounds or more or is 40 or more inches tall.");
  addRule("ca_rule_leaving_child_in_car", "Traffic Laws", "Children", "It is illegal to leave a child 6 years of age or younger unattended in a motor vehicle.", exceptions: "The child may be left under the supervision of a person 12 years of age or older.");
  
  // Collisions and Insurance (Low Priority)
  addRule("ca_rule_collision_reporting", "Collisions", "Reporting", "If you are involved in a collision resulting in an injury, death, or property damage over \$1,000, you must report it to the DMV within 10 days.");
  addRule("ca_rule_hit_and_run", "Collisions", "Hit and Run", "If you hit a parked vehicle or other property, leave a note with your name, phone number, and address securely attached to the vehicle or property.", details: "You must also report the collision to the city police or CHP.");
  addRule("ca_rule_insurance_requirements", "Insurance", "Liability", "You must carry written evidence of financial responsibility (insurance) at all times and present it when pulled over by law enforcement or after a collision.");
  addRule("ca_rule_minimum_insurance", "Insurance", "Liability", "Minimum insurance in California is \$15,000 for single injury/death, \$30,000 for multiple injury/death, and \$5,000 for property damage.");
  
  // Special California Rules
  addRule("ca_rule_smoking_with_minor", "Traffic Laws", "Smoking", "It is illegal to smoke in a motor vehicle when a minor (under 18 years old) is present.", details: "You can be fined up to \$100.");
  addRule("ca_rule_dumping_animals", "Traffic Laws", "Animals", "It is a criminal offense to dump or abandon an animal on a highway.", details: "Punishable by a fine of up to \$1,000, 6 months in jail, or both.");
  addRule("ca_rule_carrying_loads", "Vehicle Equipment", "Loads", "You may not carry anything in or on a passenger vehicle which extends beyond the fenders on the left side or more than 6 inches beyond the fenders on the right side.");
  addRule("ca_rule_red_flag_load", "Vehicle Equipment", "Loads", "Cargo extending more than 4 feet from the back rear bumper of the vehicle must display a 12-inch red or fluorescent orange square flag or two red lights at night.");
  addRule("ca_rule_littering", "Traffic Laws", "Littering", "Littering on the roadside carries a fine of \$1,000 and you may be forced to pick up what you threw away.");
  addRule("ca_rule_honking_horn", "Vehicle Equipment", "Horn", "Only use your horn to avoid collisions, to alert another driver of a hazard, or on narrow mountain roads where you cannot see at least 200 feet ahead.", exceptions: "Do not use your horn to express anger or to encourage a driver to go faster.");
  
  // Provisional License Rules (Permits)
  addRule("ca_rule_provisional_permit_driving", "Permit Restrictions", "Driving", "With a provisional permit, you must be accompanied by a licensed parent, guardian, or other licensed driver 25 years of age or older at all times.", details: "They must sit close enough to take control of the vehicle if necessary.");
  addRule("ca_rule_provisional_permit_solo", "Permit Restrictions", "Solo Driving", "A provisional instruction permit does not allow you to drive alone at any time, not even to a DMV office to take a driving test.");
  addRule("ca_rule_provisional_license_passengers", "Provisional License", "Passengers", "During the first 12 months after receiving a provisional license, you cannot transport passengers under 20 years old.", exceptions: "Unless accompanied by a licensed parent, guardian, or licensed driver 25 years or older.");
  addRule("ca_rule_provisional_license_time", "Provisional License", "Time Restrictions", "During the first 12 months, you cannot drive between 11 PM and 5 AM.", exceptions: "Exceptions exist for medical necessity, school activities, or employment, provided you carry a signed note.");
  
  // Sharing the Road
  addRule("ca_rule_sharing_motorcycles", "Sharing the Road", "Motorcycles", "Allow a four-second following distance for motorcycles. When they brake, you may not see their brake lights if they only downshift.");
  addRule("ca_rule_lane_splitting", "Sharing the Road", "Motorcycles", "Motorcyclists are permitted to lane split in California.", details: "Do not intentionally block or impede a motorcyclist in a way that could cause harm.");
  addRule("ca_rule_truck_blind_spots", "Sharing the Road", "Large Trucks", "Large trucks have much larger blind spots (No Zones) than passenger vehicles. If you cannot see the truck driver in their side mirror, they cannot see you.");
  addRule("ca_rule_truck_turning", "Sharing the Road", "Large Trucks", "Large trucks take longer to stop and need more room to turn. They often swing wide to the left to make a right turn.");
  addRule("ca_rule_light_rail_vehicles", "Sharing the Road", "Light Rail", "Never turn in front of an approaching light rail vehicle. They cannot steer off the tracks to avoid a collision.");
  
  // Emergency / Safety
  addRule("ca_rule_flashing_red_light", "Traffic Signals", "Red Lights", "A flashing red traffic signal light means 'STOP.' After stopping, you may proceed when it is safe.");
  addRule("ca_rule_solid_yellow_light", "Traffic Signals", "Yellow Lights", "A solid yellow traffic signal light means 'CAUTION.' The red traffic signal light is about to appear. Stop if you can do so safely.");
  addRule("ca_rule_flashing_yellow_light", "Traffic Signals", "Yellow Lights", "A flashing yellow traffic signal light warns you to 'PROCEED WITH CAUTION.' Slow down and be alert before entering the intersection.");
  addRule("ca_rule_flashing_yellow_arrow", "Traffic Signals", "Yellow Lights", "A flashing yellow arrow means you can turn, but your turn is not protected from other traffic. Yield to oncoming traffic and pedestrians.");
  addRule("ca_rule_blackout_traffic_light", "Traffic Signals", "Power Outage", "If a traffic signal light is not working (blackout), you must treat the intersection as if it is controlled by STOP signs in all directions.");

  final encoder = JsonEncoder.withIndent('  ');
  await File('assets/data/us/research/ca/rules.json').writeAsString(encoder.convert(rules));
  print('Successfully wrote \${rules.length} rules to rules.json');
}
