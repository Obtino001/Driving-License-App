import 'dart:convert';
import 'dart:io';

void main() async {
  final signs = <Map<String, dynamic>>[];
  
  void addSign(String id, String name, String category, String meaning, String action, String situation, String symbol, {String shape = "Diamond", String color = "Yellow"}) {
    signs.add({
      "signResearchId": id,
      "stateId": "ca",
      "officialName": name,
      "category": category,
      "meaning": meaning,
      "driverAction": action,
      "exampleSituation": situation,
      "shape": shape,
      "color": color,
      "symbol": symbol,
      "sourceId": "ca_dmv_handbook",
      "section": "Traffic Controls",
      "page": null,
      "sourceVersion": "Current",
      "contentVersion": "v1.1",
      "lastVerified": 1725015000,
      "status": "verified"
    });
  }

  // --- EXISTING 8 SIGNS ---
  addSign("ca_sign_stop", "STOP", "Regulatory", "Come to a complete stop.", "Stop completely at the solid white limit line or before entering the crosswalk/intersection.", "Approaching a four-way intersection.", "STOP", shape: "Octagon", color: "Red");
  addSign("ca_sign_yield", "YIELD", "Regulatory", "Slow down and be ready to stop to let any vehicle, bicyclist, or pedestrian pass.", "Slow down or stop if necessary.", "Merging onto a highway.", "YIELD", shape: "Triangle", color: "Red and White");
  addSign("ca_sign_wrong_way", "WRONG WAY", "Regulatory", "You are going against traffic.", "Drive to the side of the road and stop. When safe, back out or turn around.", "Entering a freeway off-ramp.", "WRONG WAY", shape: "Rectangle", color: "Red");
  addSign("ca_sign_do_not_enter", "DO NOT ENTER", "Regulatory", "Do not enter the road or off ramp.", "Do not enter.", "Driving toward a one-way street.", "DO NOT ENTER", shape: "Square", color: "Red");
  addSign("ca_sign_no_u_turn", "NO U-TURN", "Regulatory", "U-turns are illegal.", "Do not make a U-turn.", "At an intersection in a business district.", "U-turn arrow with red slash", shape: "Square", color: "White");
  addSign("ca_sign_slippery_when_wet", "Slippery When Wet", "Warning", "The road ahead is slippery when wet.", "Avoid sudden turns or hard braking. Slow down.", "Driving in the rain.", "Car with swerving tracks");
  addSign("ca_sign_school_zone", "School Zone/Crossing", "Warning", "You are near a school.", "Slow down and watch for children.", "Approaching an elementary school.", "Two children walking", shape: "Pentagon", color: "Yellow-Green");
  addSign("ca_sign_divided_highway_begins", "Divided Highway Begins", "Warning", "The highway ahead is divided by a median or physical barrier.", "Keep to the right.", "Driving on a two-lane road that becomes a divided highway.", "Two arrows with barrier at top");

  // --- NEW SIGNS TO REACH ~20+ ---
  addSign("ca_sign_merge", "Merge", "Warning", "Traffic from another lane is merging into your lane.", "Be prepared to allow vehicles to enter your lane.", "Approaching a freeway on-ramp.", "Arrow merging into straight arrow");
  addSign("ca_sign_lane_ends", "Lane Ends", "Warning", "The lane you are in is ending.", "Merge into the next lane safely.", "Driving in the right lane of a highway.", "Straight line and angled line merging");
  addSign("ca_sign_two_way_traffic", "Two-Way Traffic", "Warning", "You are on a two-way road.", "Stay in your lane and watch for oncoming traffic.", "Transitioning from a divided highway.", "Two arrows pointing in opposite directions");
  addSign("ca_sign_added_lane", "Added Lane", "Warning", "Traffic from another road will enter the highway, but they have their own lane.", "No merging is necessary.", "Passing an on-ramp where a new lane begins.", "Two arrows coming together but staying separate");
  addSign("ca_sign_pedestrian_crossing", "Pedestrian Crossing", "Warning", "A pedestrian crosswalk is ahead.", "Slow down and watch for pedestrians.", "Approaching a busy downtown intersection.", "Walking person");
  addSign("ca_sign_railroad_crossing", "Railroad Crossing", "Warning", "You are approaching a railroad crossing.", "Look, listen, and be prepared to stop.", "Approaching train tracks.", "RxR crossbuck", shape: "Circle", color: "Yellow");
  addSign("ca_sign_no_right_turn", "No Right Turn", "Regulatory", "Right turns are illegal.", "Do not turn right.", "At an intersection with heavy pedestrian traffic.", "Right arrow with red slash", shape: "Square", color: "White");
  addSign("ca_sign_keep_right", "Keep Right", "Regulatory", "Traffic must stay to the right of a divider or obstruction.", "Stay to the right.", "Approaching a traffic island.", "Arrow pointing right around an obstruction", shape: "Rectangle", color: "White");
  addSign("ca_sign_speed_limit", "Speed Limit", "Regulatory", "The maximum legal speed under ideal conditions.", "Do not exceed the posted speed.", "Driving on a city street.", "SPEED LIMIT 55", shape: "Rectangle", color: "White");
  addSign("ca_sign_one_way", "ONE WAY", "Regulatory", "Traffic flows only in the direction of the arrow.", "Drive only in the direction indicated.", "Entering a downtown grid.", "Arrow with ONE WAY text", shape: "Rectangle", color: "Black and White");
  addSign("ca_sign_hospital", "Hospital", "Guide", "A hospital is nearby.", "Follow signs if emergency services are needed.", "Approaching a medical center.", "Letter 'H'", shape: "Rectangle", color: "Blue");
  addSign("ca_sign_deer_crossing", "Deer Crossing", "Warning", "Deer often cross the road in this area.", "Be alert, especially at dusk and dawn.", "Driving through a forested area.", "Leaping deer");
  addSign("ca_sign_steep_hill", "Steep Hill", "Warning", "A steep downgrade is ahead.", "Check your brakes and shift to a lower gear.", "Driving in the mountains.", "Truck going down a hill");
  addSign("ca_sign_crossroad", "Crossroad", "Warning", "A four-way intersection is ahead.", "Watch for traffic entering from the sides.", "Approaching a rural intersection.", "Plus sign cross");
  addSign("ca_sign_yield_ahead", "Yield Ahead", "Warning", "There is a YIELD sign ahead.", "Slow down and prepare to yield.", "Approaching a roundabout.", "YIELD sign symbol");
  addSign("ca_sign_stop_ahead", "Stop Ahead", "Warning", "There is a STOP sign ahead.", "Slow down and prepare to stop.", "Approaching a hidden intersection.", "STOP sign symbol or red octagon");

  final encoder = JsonEncoder.withIndent('  ');
  await File('assets/data/us/research/ca/road_signs.json').writeAsString(encoder.convert(signs));
  print('Successfully wrote road_signs.json');
}
