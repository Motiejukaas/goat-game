public class Player{
  boolean player_is_moving = false;
  boolean player_is_cracking = false;
  int rock_state; // 2 rock; 3 half rock; 4 dirt
  int rock_hit_count = 0;
  int counter = 0; // takes 39 frames for one hit animation to pass
  
  int player_velocity = 32 / 3;
  PImage animation_image;
  PImage [][]player;
  float center_x, center_y;
  float p_w, p_h;
  int direction = 3;
  float walking_frame = 0, grazing_frame, cracking_frame;
  int player_w = 128, player_h = 128;
  
  public Player(String filename, float scale) {
    player = new PImage[8][4];
    animation_image = loadImage(filename);
    for (int i = 0; i < 8; ++i) {
      for (int j = 0; j < 4; ++j) {
        player[i][j] = animation_image.get(player_w * j, player_h * i, player_w, player_h);
      }
    }
    
    p_w = player[0][0].width * scale;
    p_h = player[0][0].height * scale;
    //actual center is 400x400
    center_x = 400 - 64;
    center_y = 400 - 64;
  }
  
  
  public void display() {
    if (!player_is_moving && !player_is_cracking) {
      image(player[direction + 4][(int)grazing_frame], center_x, center_y, p_w, p_h);
    } else if (!player_is_cracking) { 
      image(player[direction][(int)walking_frame], center_x, center_y, p_w, p_h);  
    }
  }
  
  public void update() {
    walking_frame = (walking_frame + 0.1) % 4;
    grazing_frame = (grazing_frame + 0.01) % 4;
    if (player_is_cracking) {
      cracking_frame = (cracking_frame + 0.1) % 4;
    }
  }
  
  void crackRock() {
    if(rock_state < 4) {
      ++counter;
      if (counter == 39) {
        counter = 0;
        ++rock_hit_count;
      }
      if (rock_hit_count == 4) {
        ++rock_state;
        rock_hit_count = 0;
      }
      image(player[direction + 4][(int)cracking_frame], center_x, center_y, p_w, p_h);
    } else {
      player_is_cracking = false;
    }
  }
}
