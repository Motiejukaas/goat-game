final static float SPRITE_SIZE = 16;

Player player;
Map map;

int current_level = 1, previous_level = 0;


void setup() {
  size(800, 800);
  player = new Player("data/goat.png", 1);
  map = new Map();
}

void draw() {
  background(47,129,54);
  if (current_level == 4) {
    displayWinMsg();
    map.placeRocks();
  } else {
    if (current_level > previous_level) {
      previous_level += 1;
      map.loadCSV(current_level);
      map.countCSVCoords();
    }
    map.countRocks();
    map.loadMap();
    displayInfoMsg();
    map.editMap(current_level);
    player.display();
    player.update();
    if (player.player_is_cracking == true) {
      player.crackRock();
      map.updateRock(player.rock_state, current_level);
    }
    if ((map.half_rock_count + map.rock_count) == 0) {
      ++current_level;
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    player.direction = 3;
    if (checkCollision(3) == 0) {
      player.player_is_moving = true;
      map.player_pos_x -= player.player_velocity;
    }
  } else if (keyCode == LEFT) {
    player.direction = 1;
    if (checkCollision(1) == 0) {
      player.player_is_moving = true;
      map.player_pos_x += player.player_velocity;
    }
  } else if (keyCode == UP) {
    player.direction = 0;
    if (checkCollision(0) == 0) {
      player.player_is_moving = true;
      map.player_pos_y += player.player_velocity;
    }
  } else if (keyCode == DOWN) {
    player.direction = 2;
    if (checkCollision(2) == 0) {
      player.player_is_moving = true;
      map.player_pos_y -= player.player_velocity;
    }
  } else if (keyCode == ENTER && current_level == 4) {
    current_level = 1;
    previous_level = 0;
  } else if (keyCode == ENTER) {
    map.editor_visible = !map.editor_visible;
  } else if (keyCode == SHIFT && (checkCollision(player.direction) == 2 || checkCollision(player.direction) == 3)) {
    player.cracking_frame = 0;
    player.rock_state = checkCollision(player.direction);
    player.player_is_cracking = true;
  }
}


void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT || keyCode == UP || keyCode == DOWN) {
    player.player_is_moving = false;
  }
}

int checkCollision(int direction) {
  //returns 0 if there is no collision
  //returns 1 if there is collision
  //returns 2 if the collision is with rock
  //returns 3 if the collision is with half rock
  
  //colliding cells: 1xx, 4xx, 5xx
  if (direction == 3) {
    int player_top = int((12 * map.tile_size - map.player_pos_y + player.player_velocity) / map.tile_size); // y axis
    int player_right = int((12 * map.tile_size - map.player_pos_x + player.player_velocity + 32) / map.tile_size); // x axis
    int player_bottom = int((12 * map.tile_size - map.player_pos_y + 32) / map.tile_size); // y axis
    if ((map.map_code.getInt(player_top, player_right) / 100) == 1 || (map.map_code.getInt(player_bottom, player_right) / 100) == 1 || 
        (map.map_code.getInt(player_top, player_right) / 100) == 4 || (map.map_code.getInt(player_bottom, player_right) / 100) == 4) {
          return 1;
    } else if (map.map_code.getInt(player_top, player_right) == 500) {
      map.rock_x = player_right;
      map.rock_y = player_top;
      return 2;
    } else if (map.map_code.getInt(player_bottom, player_right) == 500) {
      map.rock_x = player_right;
      map.rock_y = player_bottom;
      return 2;
    } else if (map.map_code.getInt(player_top, player_right) == 501) {
      map.rock_x = player_right;
      map.rock_y = player_top;
      return 3;
    } else if (map.map_code.getInt(player_bottom, player_right) == 501) {
      map.rock_x = player_right;
      map.rock_y = player_bottom;
      return 3;
    }
  } else if (direction == 1) {
    int player_left = int((12 * map.tile_size - map.player_pos_x - player.player_velocity) / map.tile_size); // x axis
    int player_top = int((12 * map.tile_size - map.player_pos_y + player.player_velocity) / map.tile_size); // y axis
    int player_bottom = int((12 * map.tile_size - map.player_pos_y + 32) / map.tile_size); // y axis
    if ((map.map_code.getInt(player_top, player_left) / 100) == 1 || (map.map_code.getInt(player_bottom, player_left) / 100) == 1 || 
        (map.map_code.getInt(player_top, player_left) / 100) == 4 || (map.map_code.getInt(player_bottom, player_left) / 100) == 4) {
          return 1;
    } else if (map.map_code.getInt(player_top, player_left) == 500) {
      map.rock_x = player_left;
      map.rock_y = player_top;
      return 2;
    } else if (map.map_code.getInt(player_bottom, player_left) == 500) {
      map.rock_x = player_left;
      map.rock_y = player_bottom;
      return 2;
    } else if (map.map_code.getInt(player_top, player_left) == 501) {
      map.rock_x = player_left;
      map.rock_y = player_top;
      return 3;
    } else if (map.map_code.getInt(player_bottom, player_left) == 501) {
      map.rock_x = player_left;
      map.rock_y = player_bottom;
      return 3;
    }
  } else if (direction == 0) {
    int player_left = int((12 * map.tile_size - map.player_pos_x) / map.tile_size); // x axis
    int player_top = int((12 * map.tile_size - map.player_pos_y/* - player.player_velocity*/) / map.tile_size); // y axis
    int player_right = int((12 * map.tile_size - map.player_pos_x + 32) / map.tile_size); // x axis
    if ((map.map_code.getInt(player_top, player_left) / 100) == 1 || (map.map_code.getInt(player_top, player_right) / 100) == 1 || 
        (map.map_code.getInt(player_top, player_left) / 100) == 4 || (map.map_code.getInt(player_top, player_right) / 100) == 4) {
          return 1;
    } else if (map.map_code.getInt(player_top, player_left) == 500) {
      map.rock_x = player_left;
      map.rock_y = player_top;
      return 2;
    } else if (map.map_code.getInt(player_top, player_right) == 500) {
      map.rock_x = player_right;
      map.rock_y = player_top;
      return 2;
    } else if (map.map_code.getInt(player_top, player_left) == 501) {
      map.rock_x = player_left;
      map.rock_y = player_top;
      return 3;
    } else if (map.map_code.getInt(player_top, player_right) == 501) {
      map.rock_x = player_right;
      map.rock_y = player_top;
      return 3;
    }
  } else if (direction == 2) {
    int player_left = int((12 * map.tile_size - map.player_pos_x) / map.tile_size); // x axis
    int player_right = int((12 * map.tile_size - map.player_pos_x + 32) / map.tile_size); // x axis
    int player_bottom = int((12 * map.tile_size - map.player_pos_y + player.player_velocity + 32) / map.tile_size); // y axis
    if ((map.map_code.getInt(player_bottom, player_left) / 100) == 1 || (map.map_code.getInt(player_bottom, player_right) / 100) == 1 || 
        (map.map_code.getInt(player_bottom, player_left) / 100) == 4 || (map.map_code.getInt(player_bottom, player_right) / 100) == 4) {
          return 1;
    } else if (map.map_code.getInt(player_bottom, player_left) == 500) {
      map.rock_x = player_left;
      map.rock_y = player_bottom;
      return 2;
    } else if (map.map_code.getInt(player_bottom, player_right) == 500) {
      map.rock_x = player_right;
      map.rock_y = player_bottom;
      return 2;
    } else if (map.map_code.getInt(player_bottom, player_left) == 501) {
      map.rock_x = player_left;
      map.rock_y = player_bottom;
      return 3;
    } else if (map.map_code.getInt(player_bottom, player_right) == 501) {
      map.rock_x = player_right;
      map.rock_y = player_bottom;
      return 3;
    }
  }  
  return 0;
}

void displayWinMsg() {
  textAlign(CENTER);
  textSize(40);
  text("YOU WON!", width/2, height/2);
}

void displayInfoMsg() {
  strokeJoin(ROUND);
  strokeWeight(2);
  stroke(60, 34, 24);
  fill(72, 60, 50);
  rect(638, 2  , 160, 96);
  
  strokeWeight(4);
  textAlign(LEFT);
  textSize(40);
  fill(179, 139, 109);
  text("Level " + current_level, 645, 33);
  textSize(25);
  text("Rocks left: " + map.rock_count, 645, 60);
  text("Pebbles left: " + map.half_rock_count, 645, 90);
  strokeWeight(1);
}
  
