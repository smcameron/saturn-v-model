/*
 * Saturn V
 *
 * First stage 33x138 feet
 * 2nd stage 33x81 feet
 * 3rd stage 22x59 feet
 *
 * total vehicle length 281 feet
 * total length (vehicle + spacecraft + LES) 363 feet
 * instrument unit 22x3 feet
 *  
 *
 * note: 81 + 59 + 138 = 286 (not 281, not 284)
 * so these numbers are a bit fuzzy.
 * 
 */

stage_one_h = 138;
stage_one_r = (33 / 2.0);

stage_two_h = 81;
stage_two_r = (33 / 2.0);

stage_23_neck_h = 22;

instrument_h = 3;
stage_three_h = (59 + instrument_h);
stage_three_r = (22 / 2.0);

capsule_h = 9.33;
capsule_r = (12.83 / 2.0);
capsule_top_r = 1.5; /* a guess */
last_neck_h = 30; /* this is a guess */

engine_housing_r = 101 / 12.0;
engine_housing_h = 4 * engine_housing_r;

cmd_module_h = 15; /* a guess */

$fn=40;

module stage_one()
{
	difference() {
		cylinder(h = stage_one_h, r1 = stage_one_r, r2 = stage_one_r, center = true);	
		cylinder(h = stage_one_h + 1, r1 = (stage_one_r - 1),
						r2 = (stage_one_r - 1), center = true);	
	}
}

module stage_two()
{
	difference() {
		cylinder(h = stage_two_h, r1 = stage_two_r, r2 = stage_two_r, center = true);	
		cylinder(h = stage_two_h + 1, r1 = stage_two_r - 1, r2 = stage_two_r - 1,
					center = true);	
	}
}

module stage_three()
{
	difference() {
		cylinder(h = stage_three_h, r1 = stage_three_r,
					r2 = stage_three_r, center = true);	
		cylinder(h = stage_three_h + 1, r1 = stage_three_r - 0.5,
					r2 = stage_three_r - 0.5, center = true);	
	}
}

module stage_two_three_neck_down()
{
	difference() {
		cylinder(h = stage_23_neck_h, r1 = stage_two_r, r2 = stage_three_r, center = true); 
		cylinder(h = stage_23_neck_h + 0.5, r1 = stage_two_r - 0.5,
						r2 = stage_three_r - 0.5, center = true); 
	}
}

module top_neck_down()
{
	difference() {
		cylinder(h = last_neck_h, r1 = stage_three_r, r2 = capsule_r, center = true);
		cylinder(h = last_neck_h + 0.5, r1 = stage_three_r - 0.5,
						r2 = capsule_r - 0.5, center = true);
	}
}

module cmd_module()
{
	difference() {
		cylinder(h = cmd_module_h, r1 = capsule_r, r2 = capsule_r, center = true);
		cylinder(h = cmd_module_h + 1, r1 = capsule_r - 1, r2 = capsule_r - 1,
			center = true);
	}
}
	
module capsule()
{
	difference() {
		union() { 
			cylinder(h = capsule_h, r1 = capsule_r, r2 = capsule_top_r, center = true); 
			translate(v = [0, 0, 0.93 * capsule_h / 2.0])
				sphere(r = capsule_top_r);
		}
		translate(v = [0, 0, -capsule_h * 0.6])
			sphere(r = capsule_r * 0.9);
	}
}

module engine_housing()
{
	difference() {
		cylinder(h = engine_housing_h, r1 = engine_housing_r, r2 = 0, center = true);
		translate(v = [0, 0, -1])
			cylinder(h = engine_housing_h, r1 = engine_housing_r, r2 = 0, center = true);
	}
}

module engine_housings()
{
	translate(v = [stage_one_r, 0, engine_housing_h / 2.0])
		engine_housing();
	translate(v = [-stage_one_r, 0, engine_housing_h / 2.0])
		engine_housing();
	translate(v = [0, stage_one_r, engine_housing_h / 2.0])
		engine_housing();
	translate(v = [0, -stage_one_r, engine_housing_h / 2.0])
		engine_housing();
}

module fin()
{
	translate(v = [0, -25, 6]) {
		difference() {
			cube(size = [1.25, 20, 12], center = true);
			translate(v = [0, 0, 10]) {
				rotate(a = 18, v = [1, 0, 0])
					cube(size = [4.25, 30, 12], center = true);
			}
		}
	}
}

module fins()
{
	fin();
	rotate(a = 90, v = [0, 0, 1])
		fin();
	rotate(a = 180, v = [0, 0, 1])
		fin();
	rotate(a = 270, v = [0, 0, 1])
		fin();
}

module saturn_v()
{
	translate(v = [0, 0, stage_one_h / 2.0]) {
	union() {
	stage_one();
	translate(v = [0, 0, stage_one_h / 2.0 + 81 / 2.0 - 0.2]) {
		stage_two();
		translate( v = [0, 0, 81 / 2.0 + 22 / 2.0 - 0.5]) {
			stage_two_three_neck_down();
			translate(v = [0, 0, stage_23_neck_h / 2.0 + stage_three_h / 2.0 - 0.5]) {
				stage_three();
				translate(v = [0, 0, stage_three_h / 2.0 + last_neck_h / 2.0 - 0.5]) {
					top_neck_down();
					translate(v = [0, 0, last_neck_h / 2.0 + cmd_module_h / 2.0 - 0.25]) {
						cmd_module();
						translate(v = [0, 0, cmd_module_h / 2.0 + capsule_h / 2.0 - 0.25]) {
							capsule();
						}
					}
				}
			}
		}
	}
	}
	}
	engine_housings();
	fins();
}

union()
	saturn_v();

	
