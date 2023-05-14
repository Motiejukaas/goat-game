public class Map{
  PImage temp_image;
  PImage [][]watergrass;
  PImage [][]grass;
  PImage [][]dirt;
  PImage [][]hole;
  PImage []rock;
  int tile_size = 32;
  
  Table map_code;
  int map_x, map_y;
  
  int player_pos_x = 0, player_pos_y = 0;
  
  int screen = 800;
  boolean editor_visible = false;
  int selected_tile = 0;
  
  int half_rock_count = 0, rock_count = 0;
  int rock_x, rock_y;
    
  Map() {   
    cutMap();
    placeRocks();
  }
  
  public void cutMap() {
    watergrass = new PImage[6][3];
    temp_image = loadImage("data/watergrass.png");
    for (int i = 0; i < 6; ++i) {
      for (int j = 0; j < 3; ++j) {
        watergrass[i][j] = temp_image.get(tile_size * j, tile_size * i, tile_size, tile_size);
      }
    }
    
    grass = new PImage[6][3];
    temp_image = loadImage("data/grass.png");
    for (int i = 0; i < 6; ++i) {
      for (int j = 0; j < 3; ++j) {
        grass[i][j] = temp_image.get(tile_size * j, tile_size * i, tile_size, tile_size);
      }
    }
    
    dirt = new PImage[6][3];
    temp_image = loadImage("data/dirt.png");
    for (int i = 0; i < 6; ++i) {
      for (int j = 0; j < 3; ++j) {
        dirt[i][j] = temp_image.get(tile_size * j, tile_size * i, tile_size, tile_size);
      }
    }
    
    hole = new PImage[6][3];
    temp_image = loadImage("data/hole.png");
    for (int i = 0; i < 6; ++i) {
      for (int j = 0; j < 3; ++j) {
        hole[i][j] = temp_image.get(tile_size * j, tile_size * i, tile_size, tile_size);
      }
    }
    
    rock = new PImage[2];
    temp_image = loadImage("data/rock.png");
    for (int i = 0; i < 2; ++i) {
      rock[i] = temp_image.get(tile_size * i, tile_size * 0, tile_size, tile_size);
    }
  }
  
  void loadMap() {
    randomSeed(124);
    for (int i = 0; i < map_y; ++i) {
      for (int j = 0; j < map_x; ++j) {
        image(grass[5][(int)random(0, 3)], (i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
      }
    }
    
    for (int i = 0; i < map_y; ++i) {
      for (int j = 0; j < map_x; ++j) {
        int tile_code = map_code.getInt(j, i);
        //first digit - file, second digit - row, third digit - column
        if ((int)(tile_code / 100) == 1) {
          image(watergrass[(tile_code % 100) / 10][tile_code % 10],(i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
        } else if ((int)(tile_code / 100) == 2) {
          image(grass[(tile_code % 100) / 10][tile_code % 10],(i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
        } else if ((int)(tile_code / 100) == 3) {
          image(dirt[(tile_code % 100) / 10][tile_code % 10],(i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
        } else if ((int)(tile_code / 100) == 4) {
          image(hole[(tile_code % 100) / 10][tile_code % 10],(i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
        } else if ((int)(tile_code / 100) == 5) {
          image(rock[tile_code % 10],(i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y);
        }        
      }
    }
  }
  
  void editMap(int current_level){
    if (editor_visible) {
      noFill();
      stroke(241, 41, 88);
      for(int i = 0; i < map_y; ++i){
        for(int j = 0; j < map_x; ++j){
          rect((i * tile_size) + player_pos_x, (j * tile_size) + player_pos_y, tile_size, tile_size);
        }
      }
      
      
      for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 3; ++j) {
          image(watergrass[i][j], j * tile_size, i * tile_size);
        }
      }
    
      for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 3; ++j) {
          image(grass[i][j], j * tile_size, i * tile_size + 192);
        }
      }
      
      for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 3; ++j) {
          image(dirt[i][j], j * tile_size, i * tile_size + 384);
        }
      }
      
      for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 3; ++j) {
          image(hole[i][j], j * tile_size, i * tile_size + 576);
        }
      }
      
      for (int i = 0; i < 2; ++i) {
          image(rock[i], i * tile_size, 768);
      }      
      
      // x: 96  y: 192
      //first digit - file, second digit - row, third digit - column
      if (mousePressed) {
        if (mouseX <= 96 && mouseY <= 192) {
          selected_tile = 100 + ((int)mouseY/tile_size * 10) + (int)mouseX/tile_size;
        } else if (mouseX <= 96 && mouseY > 192 && mouseY <= 384) {
          selected_tile = 200 + (((int)mouseY/tile_size - 6) * 10) + (int)mouseX/tile_size;
        } else if (mouseX <= 96 && mouseY > 384 && mouseY <= 576) {
          selected_tile = 300 + (((int)mouseY/tile_size - 12) * 10) + (int)mouseX/tile_size;
        } else if (mouseX <= 96 && mouseY >= 576 && mouseY <= 768) {
          selected_tile = 400 + (((int)mouseY/tile_size - 18) * 10) + (int)mouseX/tile_size;
        } else if (mouseX <= 64 && mouseY >= 768 && mouseY <= 800) {
          selected_tile = 500 + (((int)mouseY/tile_size - 24) * 10) + (int)mouseX/tile_size;
        } else if (mouseX > 64 && mouseY >= 768 && mouseY <= 800) {
          selected_tile = 0;
        }
      }
      
      if ((int)(selected_tile / 100) == 1) {
        image(watergrass[(selected_tile % 100) / 10][selected_tile % 10], mouseX, mouseY);
      } else if ((int)(selected_tile / 100) == 2) {
        image(grass[(selected_tile % 100) / 10][selected_tile % 10], mouseX, mouseY);
      } else if ((int)(selected_tile / 100) == 3) {
        image(dirt[(selected_tile % 100) / 10][selected_tile % 10], mouseX, mouseY);
      } else if ((int)(selected_tile / 100) == 4) {
        image(hole[(selected_tile % 100) / 10][selected_tile % 10], mouseX, mouseY);
      } else if ((int)(selected_tile / 100) == 5) {
        image(rock[selected_tile % 10], mouseX, mouseY);
      }
      
      boolean map_edited = false;
      if (mousePressed && mouseX > 96) {
        map_code.setInt((int)(mouseY - player_pos_y) / tile_size, (int)(mouseX - player_pos_x) / tile_size, selected_tile);
        map_edited = true;
      }
      if (map_edited) {
        saveTable(map_code, "level" + current_level + ".csv");
      }
    }
  }
  
  void countRocks() {
    int temp_rock_count = 0, temp_half_rock_count = 0;
    for (int i = 0; i < map_y; ++i) {
      for (int j = 0; j < map_x; ++j) {
        int tile_code = map_code.getInt(j, i);
        if (tile_code == 500) {
          temp_rock_count++;
        } else if (tile_code == 501) {
          temp_half_rock_count++;
        }
      }
    }
    rock_count = temp_rock_count;
    half_rock_count = temp_half_rock_count;
  }
  
  void countCSVCoords() {
    map_x = map_code.getColumnCount();
    map_y = map_code.getRowCount();
  }
  
  void loadCSV(int current_level) {
    map_code = loadTable("level" + current_level + ".csv");
  }
  
  void updateRock(int rock_state, int current_level) {
    // 2 rock; 3 half rock; 4 dirt
    if (rock_state == 3) {
      map_code.setInt(rock_y, rock_x, 501);
      saveTable(map_code, "level" + current_level + ".csv");
    } else if (rock_state == 4) {
      map_code.setInt(rock_y, rock_x, 300);
      saveTable(map_code, "level" + current_level + ".csv");
    }
  }
  
  void placeRocks() {
    for (int i = 1; i < 4; ++i) {
      map_code = loadTable("level" + i + ".csv");
      
      countCSVCoords();
      for (int j = 0; j < map_x; ++j) {
        for (int k = 0; k < map_y; ++k) {
          if (map_code.getInt(k, j) == 500 || map_code.getInt(k, j) == 501) {
            map_code.setInt(k, j, 0);
          }
        }
      }     
      
      int rock_num = (int)random(15);
      
      for (int j = 0; j < rock_num; ++j) {
        int rock_state = (int)random(2);
        int x = (int)random(3, 46);
        int y = (int)random(3, 46);
        
        if (map_code.getInt(y, x) == 0) {
          if (rock_state == 0) {
            map_code.setInt(y, x, 501);
          } else {
            map_code.setInt(y, x, 500);
          }
        } else {
          --rock_num; 
        }
      }
      
      saveTable(map_code, "level" + i + ".csv");
    }
  }
  
}
