
[reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")
[reflection.assembly]::LoadWithPartialName( "System.Drawing")
[reflection.assembly]::LoadWithPartialName( "System.Drawing.Color")




# function galaxy_mainloop() {
  

$signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
'@
# load signatures and make members available
$API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru

function checkASCII() {
    for ($ascii = 9; $ascii -le 254; $ascii++) {
        # get current key state
        $state = $API::GetAsyncKeyState($ascii)

        # is key pressed?
        if ($state -eq -32767) {
            $null = [console]::CapsLock
            Write-Output $ascii
       
        }
    }
}






Write-Host 'Game started. Press ESC to exit.' -ForegroundColor Red

$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @(600, 600)
$form.StartPosition = "CenterScreen"    
$formGraphics = $form.createGraphics()
$form.BackColor = [System.Drawing.Color]::Black
$form.Show()


while($true){
    
    if (  ($API::GetAsyncKeyState(27)) ) {
        exit
    }
    if (  ($API::GetAsyncKeyState(13)) ) {
        $form.Dispose()
        break
    }
 

    $startLabel = New-Object System.Windows.Forms.Label
    $startLabel.Location = New-Object System.Drawing.Size((0), (30) )
    $startLabel.Size = New-Object System.Drawing.Size(560,100) 
    $startLabel.Text = "GALAXY GAME"
    $startLabel.TextAlign = "MiddleCenter"
    $startLabel.Font = New-Object System.Drawing.Font("Impact",50,[System.Drawing.FontStyle]::Italic)
    $startLabel.Forecolor = [System.Drawing.Color]::FromName("cyan")
    $startLabel.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($startLabel) 

    $playLabel = New-Object System.Windows.Forms.Label
    $playLabel.Location = New-Object System.Drawing.Size((0), (180)) 
    $playLabel.Size = New-Object System.Drawing.Size(570,100) 
    $playLabel.Text = "Press ESC for quit or ENTER to play the game"
    $playLabel.TextAlign = "MiddleCenter"
    $playLabel.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
    $playLabel.Forecolor = [System.Drawing.Color]::FromName("pink")
    $playLabel.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($playLabel) 
    

    $controlLabel = New-Object System.Windows.Forms.Label
    $controlLabel.Location = New-Object System.Drawing.Size((0), (240)) 
    $controlLabel.Size = New-Object System.Drawing.Size(570,100) 
    $controlLabel.Text = "Player 1 controls: ARROWS + NUM 0"
    $controlLabel.TextAlign = "MiddleCenter"
    $controlLabel.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
    $controlLabel.Forecolor = [System.Drawing.Color]::FromName("green")
    $controlLabel.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($controlLabel) 

    $controlLabel_2 = New-Object System.Windows.Forms.Label
    $controlLabel_2.Location = New-Object System.Drawing.Size((0), (300)) 
    $controlLabel_2.Size = New-Object System.Drawing.Size(570,100) 
    $controlLabel_2.Text = "  Player 2 controls: WASD + SPACE"
    $controlLabel_2.TextAlign = "MiddleCenter"
    $controlLabel_2.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
    $controlLabel_2.Forecolor = [System.Drawing.Color]::FromName("red")
    $controlLabel_2.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($controlLabel_2) 


    $authorsLabel = New-Object System.Windows.Forms.Label
    $authorsLabel.Location = New-Object System.Drawing.Size((0), (400)) 
    $authorsLabel.Size = New-Object System.Drawing.Size(570,100) 
    $authorsLabel.Text = "Author Patryk Sulej"
    $authorsLabel.TextAlign = "MiddleCenter"
    $authorsLabel.Font = New-Object System.Drawing.Font("Lucida Console",10,[System.Drawing.FontStyle]::Regular)
    $authorsLabel.Forecolor = [System.Drawing.Color]::FromName("gray")
    $authorsLabel.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($authorsLabel) 



    $form.Refresh()



}






do{

$programExit = $false


[bool] $gameOver = $false



$form_width = 600
$form_height = 800

$bound_top = 500
$bound_bottom = 0

$bound_left = 0
$bound_right = 764

$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @($form_height, $form_width)
$form.StartPosition = "CenterScreen"    


$formGraphics = $form.createGraphics()
$form.BackColor = [System.Drawing.Color]::Black


$star_width = 50
$star_height = 50

$star_x = 360
$star_y = 250

$star_center_x = $star_x + $star_width/2
$star_center_y = $star_y + $star_height/2


$player_width = 20
$player_height = 60


# Player 1 green
$player1_x = 380
$player1_y =  500
$player1_v = 0.4
$player_1_hits = 0

$p1_bullet_v = 1.9
$p1_bullet_width = 5
$p1_bullet_height = 15
$p1_bullet_exists = 0

# Player 2 red 
$player2_x =  380
$player2_y = 1
$player2_v = 0.4
$player_2_hits = 0

$p2_bullet_v = 1.9
$p2_bullet_width = 5
$p2_bullet_height = 15
$p2_bullet_exists = 0


# WALLS
$x_dist = 280
$y_dist = 100

$x_dist_2 = 120
$y_dist_2 = 50

$wall_type_1_width = 40
$wall_type_1_height = 10


$wall1_left_center_x = $star_center_x - $x_dist
$wall1_left_center_y = $star_center_y + $y_dist

$wall1_left_x = $wall1_left_center_x - $wall_type_1_width/2
$wall1_left_y = $wall1_left_center_y - $wall_type_1_height/2

$wall1_right_center_x = $star_center_x + $x_dist_2
$wall1_right_center_y = $star_center_y + $y_dist_2

$wall1_right_x = $wall1_right_center_x - $wall_type_1_width/2
$wall1_right_y = $wall1_right_center_y - $wall_type_1_height/2


$wall2_left_center_x = $star_center_x - $x_dist_2
$wall2_left_center_y = $star_center_y - $y_dist_2

$wall2_left_x = $wall2_left_center_x - $wall_type_1_width/2
$wall2_left_y = $wall2_left_center_y - $wall_type_1_height/2

$wall2_right_center_x = $star_center_x + $x_dist
$wall2_right_center_y = $star_center_y - $y_dist

$wall2_right_x = $wall2_right_center_x - $wall_type_1_width/2
$wall2_right_y = $wall2_right_center_y - $wall_type_1_height/2







$dataPanel = New-Object Windows.Forms.TableLayoutPanel
$form.Show() 

#brushes
$p2_brush = New-Object Drawing.SolidBrush red
$p1_brush = New-Object Drawing.SolidBrush green
$gravity_star_brush = New-Object Drawing.SolidBrush yellow
$wall_brush = New-Object Drawing.SolidBrush purple

# $dataPanel.add_paint(
# {
# $formGraphics.Clear([System.Drawing.Color]::Black)

# }
# )

$GAMEOVER_HITS = 6


### WASD + SPACE
$p1Info = "Player 1 ♥♥♥♥♥♥" 
$p1Label = New-Object System.Windows.Forms.Label
$p1Label.Location = New-Object System.Drawing.Size(($bound_left), ($bound_top + 40)) 
$p1Label.Size = New-Object System.Drawing.Size(200,20) 
$p1Label.Text = $p1Info
$p1Label.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
$p1Label.Forecolor = [System.Drawing.Color]::FromName("green")
$p1Label.BackColor = [System.Drawing.Color]::Transparent
$form.Controls.Add($p1Label) 



### ARROWS + NUM 0
$p2Info = "Player 2 ♥♥♥♥♥♥"
$p2Label = New-Object System.Windows.Forms.Label
$p2Label.Location = New-Object System.Drawing.Size(($bound_left), ($bound_bottom)) 
$p2Label.Size = New-Object System.Drawing.Size(200,20) 
$p2Label.Text = $p2Info 
$p2Label.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
$p2Label.Forecolor = [System.Drawing.Color]::FromName("red")
$p2Label.BackColor = [System.Drawing.Color]::Transparent
$form.Controls.Add($p2Label) 




$refresh = 1







## MAIN LOOP
DO {

    $dataPanel.Dispose()

    ### BULLET MOVEMENT

    if (($API::GetAsyncKeyState(32)) -and ($p2_bullet_exists -eq 0) ) {
        $refresh = 1
        $p2_bullet_exists = 1

     
        #starting pos
        $p2_bullet_x = $player2_x + $player_width/2
        $p2_bullet_y = $player2_y + $player_height - $p2_bullet_height
        # Write-Output "Player 2 UP CLICKED"
      
    } 
    if (( $API::GetAsyncKeyState(45)) -and ($p1_bullet_exists -eq 0)  ) {
        $refresh = 1
        $p1_bullet_exists = 1

        #starting pos
        $p1_bullet_x = $player1_x + $player_width/2
        $p1_bullet_y = $player1_y - $p1_bullet_height
 

      
    } 



    ### PLAYER MOVEMENT
    # UP
    if ($API::GetAsyncKeyState([int][char]'W')) {
        # Player 2 moves up [W BUTTON]
        $player2_y = $player2_y - $player2_v
        $refresh = 1
        # Write-Output "Player 2 UP CLICKED"
    } 

    if (  ($API::GetAsyncKeyState(38)) ) {
        # Player 1 moves up [ARROW UP]
        $player1_y = $player1_y - $player1_v
        $refresh = 1


        # Write-Output "Player 1 UP CLICKED"
    } 


    ## DOWN
    if ( ($API::GetAsyncKeyState([int][char]'S')) ) {
        # Player 2 moves down [S BUTTON]
        $player2_y = $player2_y + $player2_v
        $refresh = 1
        # Write-Output "Player 2 DOWN CLICKED"
    } 

    if ( ($API::GetAsyncKeyState(40)) ) {
        # Player 1 moves down [ARROW DOWN]
        $player1_y = $player1_y + $player1_v
        # Write-Output "Player 1 DOWN CLICKED"
        $refresh = 1
    } 


    ## RIGHT
    if ( ($API::GetAsyncKeyState([int][char]'D')) ) {
        # Player 2 moves RIGHT [D BUTTON]
        $player2_x = $player2_x + $player2_v
        # Write-Output "Player 2 RIGHT CLICKED"
        $refresh = 1
    } 

    if (  ($API::GetAsyncKeyState(39))  ) {
        # Player 1  moves RIGHT [ARROW RIGHT]
        $player1_x = $player1_x + $player1_v
        $refresh = 1
        # Write-Output "Player 1 RIGHT CLICKED"
    } 


    ## LEFT
    if ($API::GetAsyncKeyState([int][char]'A')) {
        # Player 2 moves LEFT [A BUTTON]
        $player2_x = $player2_x - $player2_v
        $refresh = 1
        # Write-Output "Player 2 LEFT CLICKED"
    } 

    if (  ($API::GetAsyncKeyState(37)) ) {
        # Player 1 moves LEFT [ARROW LEFT]

        $player1_x = $player1_x - $player1_v
        $refresh = 1
        
        # Write-Output "Player 1 LEFT CLICKED"
    } 


    ### BOUNDARIES

    if($player1_y -ge $bound_top){
        $player1_y = $bound_top
        
    }
    if($player1_y -lt $bound_bottom){
        $player1_y = $bound_bottom
    }
    if($player2_y -ge $bound_top){
        $player2_y = $bound_top
    }
    if($player2_y -lt $bound_bottom){
        $player2_y = $bound_bottom
    }

 





    if($player1_x -ge $bound_right){
        $player1_x = $bound_right
        
    }
    if($player1_x -lt $bound_left){
        $player1_x = $bound_left
    }
    if($player2_x -ge $bound_right){
        $player2_x = $bound_right
        
    }
    if($player2_x -lt $bound_left){
        $player2_x = $bound_left
    }

    








    if($p1_bullet_exists -eq 1){
        ## Player 2 shot
        if( ($p1_bullet_x + $p1_bullet_width -ge $player2_x) -and ($p1_bullet_x -le $player2_x + $player_width) -and ($p1_bullet_y -le $player2_y + $player_height) -and ($p1_bullet_y + $p1_bullet_height -ge $player2_y ))
        {
            $p1_bullet_exists = 0
            
            $player_2_hits =  $player_2_hits + 1

            $p2Label.Dispose()
            $form.Controls.Remove($p2Label)
            

            $p2Label = New-Object System.Windows.Forms.Label
            $p2Label.Location = New-Object System.Drawing.Size(($bound_left), ($bound_bottom)) 
            $p2Label.Size = New-Object System.Drawing.Size(200,20) 
            $p2Label.Text =  $p2Info.Substring(0, $p2Info.Length - $player_2_hits)
            $p2Label.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
            $p2Label.Forecolor = [System.Drawing.Color]::FromName("red")
            $p2Label.BackColor = [System.Drawing.Color]::Transparent
            $form.Controls.Add($p2Label) 
            


            
        }
        #p1_bullet_walls collision
        
        if( ($p1_bullet_x + $p1_bullet_width -ge $wall1_left_x) -and ($p1_bullet_x -le $wall1_left_x + $wall_type_1_width) -and ($p1_bullet_y -le $wall1_left_y + $wall_type_1_height) -and ($p1_bullet_y + $p1_bullet_height -ge $wall1_left_y )){

            $p1_bullet_exists = 0
            $refresh = 1
        }

        if( ($p1_bullet_x + $p1_bullet_width -ge $wall1_right_x) -and ($p1_bullet_x -le $wall1_right_x + $wall_type_1_width) -and ($p1_bullet_y -le $wall1_right_y + $wall_type_1_height) -and ($p1_bullet_y + $p1_bullet_height -ge $wall1_right_y )){

            $p1_bullet_exists = 0
            $refresh = 1
        }




        if( ($p1_bullet_x + $p1_bullet_width -ge $wall2_left_x) -and ($p1_bullet_x -le $wall2_left_x + $wall_type_1_width) -and ($p1_bullet_y -le $wall2_left_y + $wall_type_1_height) -and ($p1_bullet_y + $p1_bullet_height -ge $wall2_left_y )){

            $p1_bullet_exists = 0
            $refresh = 1
        }

        if( ($p1_bullet_x + $p1_bullet_width -ge $wall2_right_x) -and ($p1_bullet_x -le $wall2_right_x + $wall_type_1_width) -and ($p1_bullet_y -le $wall2_right_y + $wall_type_1_height) -and ($p1_bullet_y + $p1_bullet_height -ge $wall2_right_y )){

            $p1_bullet_exists = 0
            $refresh = 1
        }



        # out of bounds
        if(($p1_bullet_y -le $bound_bottom )){#-or ($p1_bullet_y -lt $bound_bottom) -or ($p1_bullet_x -ge $bound_right) -or ($p1_bullet_x -lt $bound_left)   ){
            $p1_bullet_exists = 0
         
        }
        else{
            $p1_bullet_y =  $p1_bullet_y -  $p1_bullet_v
        }
            $refresh = 1


   

    }
    if($p2_bullet_exists -eq 1){
       
        # player 1 shot 
        if( ($p2_bullet_x + $p2_bullet_width -ge $player1_x) -and ($p2_bullet_x -le $player1_x + $player_width) -and ($p2_bullet_y + $p2_bullet_height -ge $player1_y) -and ($p2_bullet_y -le $player1_y + $player_height))
        {
             $p2_bullet_exists = 0
            

            $player_1_hits =  $player_1_hits + 1

            $p1Label.Dispose()
            $form.Controls.Remove($p1Label)
            
            $p1Label = New-Object System.Windows.Forms.Label
            $p1Label.Location = New-Object System.Drawing.Size(($bound_left), ($bound_top + 40)) 
            $p1Label.Size = New-Object System.Drawing.Size(200,20) 
            $p1Label.Text =  $p1Info.Substring(0, $p1Info.Length - $player_1_hits)
            $p1Label.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
            $p1Label.Forecolor = [System.Drawing.Color]::FromName("green")
            $p1Label.BackColor = [System.Drawing.Color]::Transparent
            $form.Controls.Add($p1Label) 


        }

          # p2_bullet walls colision

          if( ($p2_bullet_x + $p2_bullet_width -ge $wall1_left_x) -and ($p2_bullet_x -le $wall1_left_x + $wall_type_1_width) -and ($p2_bullet_y + $p2_bullet_height -ge $wall1_left_y) -and ($p2_bullet_y + $p2_bullet_height -le $wall1_left_y + $wall_type_1_height ) ) {
            $p2_bullet_exists = 0
            $refresh = 1
            
        }

        if( ($p2_bullet_x + $p2_bullet_width -ge $wall1_right_x) -and ($p2_bullet_x -le $wall1_right_x + $wall_type_1_width) -and  ($p2_bullet_y + $p2_bullet_height -ge $wall1_right_y) -and ($p2_bullet_y + $p2_bullet_height -le $wall1_right_y + $wall_type_1_height )){

            $p2_bullet_exists = 0
            $refresh = 1
        }


        

        if( ($p2_bullet_x + $p2_bullet_width -ge $wall2_left_x) -and ($p2_bullet_x -le $wall2_left_x + $wall_type_1_width) -and  ($p2_bullet_y + $p2_bullet_height -ge $wall2_left_y) -and ($p2_bullet_y + $p2_bullet_height -le $wall2_left_y + $wall_type_1_height )){

            $p2_bullet_exists = 0
            $refresh = 1
        }

        if( ($p2_bullet_x + $p2_bullet_width -ge $wall2_right_x) -and ($p2_bullet_x -le $wall2_right_x + $wall_type_1_width) -and  ($p2_bullet_y + $p2_bullet_height -ge $wall2_right_y) -and ($p2_bullet_y + $p2_bullet_height -le $wall2_right_y + $wall_type_1_height ) ){

            $p2_bullet_exists = 0
            $refresh = 1
        }






        #out of bounds
        if(($p2_bullet_y -ge $bound_top + 100)){#-or ($p1_bullet_y -lt $bound_bottom) -or ($p1_bullet_x -ge $bound_right) -or ($p1_bullet_x -lt $bound_left)   ){
            $p2_bullet_exists = 0
        }
        else{
            $p2_bullet_y =  $p2_bullet_y + $p2_bullet_v
        }
            $refresh = 1
        
       

  
    }
  
 
    # STAR GRAVITY

    



  
    


    ##### GAME OVER
    if( ($player_1_hits -eq $GAMEOVER_HITS) -or ($player_2_hits -eq $GAMEOVER_HITS) ){
       # $gameOver = $true
        $refresh = 1
        $gameOver = $true
        $gameOverLabel = New-Object System.Windows.Forms.Label
        $gameOverLabel.Location = New-Object System.Drawing.Size(($bound_right/2 - 350/2), ($bound_top/2)) 
        $gameOverLabel.Size = New-Object System.Drawing.Size(350,70) 
        $gameOverLabel.Text = "GAME OVER"
        $gameOverLabel.Font = New-Object System.Drawing.Font("Impact",50,[System.Drawing.FontStyle]::Regular)
        $gameOverLabel.Forecolor = [System.Drawing.Color]::FromName("cyan")
        $gameOverLabel.BackColor = [System.Drawing.Color]::Transparent
        $form.Controls.Add($gameOverLabel) 


        $playAgain = New-Object System.Windows.Forms.Label
        $playAgain.Location = New-Object System.Drawing.Size(($bound_right/2 - 350/2), ($bound_top/2 + 100)) 
        $playAgain.Size = New-Object System.Drawing.Size(350,70) 
 
        $playAgain.Text = "Press ESC for quit or ENTER o play again"
        $playAgain.Font = New-Object System.Drawing.Font("Impact",20,[System.Drawing.FontStyle]::Regular)
        $playAgain.Forecolor = [System.Drawing.Color]::FromName("pink")
        $playAgain.BackColor = [System.Drawing.Color]::Transparent
        $form.Controls.Add($playAgain) 
        $form.Refresh()


    }

    

    $p1_distance_x = $player1_x + $player_width/2 - $star_center_x
    $p1_distance_y = $player1_y + $player_height/2 - $star_center_y

    $p2_distance_x = $player2_x + $player_width/2 - $star_center_x
    $p2_distance_y = $player2_y + $player_height/2 - $star_center_y 

    
    $p2_distance = [math]::Sqrt(  [math]::Pow( ($star_center_x - $player2_x) , 2) + [math]::Pow( ($star_center_y - $player2_y) , 2))
 

    $p1_distance = [math]::Sqrt(  [math]::Pow( ($star_center_x - $player1_x) , 2) + [math]::Pow( ($star_center_y - $player1_y) , 2))


    $gravity_const = 10
    $p1_grav_speed_x = $gravity_const * 1 /$p1_distance
    $p1_grav_speed_y =  $gravity_const * 1 /$p1_distance


    $p2_grav_speed_x =  $gravity_const * 1 /$p2_distance
    $p2_grav_speed_y =  $gravity_const * 1 /$p2_distance
    

    # Player 1 gravity
    if($p1_distance_x -gt 0){
        $player1_x = $player1_x - $p1_grav_speed_x 
        $refresh = 1
        
    }

    if($p1_distance_x -lt 0){
        $player1_x = $player1_x + $p1_grav_speed_x 
        $refresh = 1

    }
    if($p1_distance_y -gt 0){
        $player1_y = $player1_y -  $p1_grav_speed_y
        $refresh = 1
        
    }

    if($p1_distance_y-lt 0){
        $player1_y = $player1_y +  $p1_grav_speed_y
        $refresh = 1
    }

      # Player 2 gravity
      if($p2_distance_x -gt 0){
        $player2_x = $player2_x -   $p2_grav_speed_x
        $refresh = 1
        
    }
    if($p2_distance_x -lt 0){
        $player2_x = $player2_x +   $p2_grav_speed_x
        $refresh = 1
    }
    if($p2_distance_y -gt 0){
        $player2_y = $player2_y - $p2_grav_speed_y
    }

    if($p2_distance_y -lt 0){
        $player2_y = $player2_y +  $p2_grav_speed_y
        $refresh = 1
    }



    # SCREEN REFRESH
    if ($refresh -eq 1) {

        $form.Controls.Remove($dataPanel)
        
        $dataPanel = New-Object Windows.Forms.TableLayoutPanel
        $dataPanel.Size = New-Object Drawing.Size @(1, 1)
        # $dataPanel.Dock = "Fill"
        # $dataPanel.AutoScroll = $true
        #$dataPanel.BackColor = "Transparent"
        $dataPanel.add_paint( {
                #$formGraphics.Clear([System.Drawing.Color]::Black)
                $player_2_rect = new-object Drawing.Rectangle  $player2_x, $player2_y, $player_width, $player_height
                $formGraphics.FillRectangle($p2_brush, $player_2_rect)


               
                
                if($p2_bullet_exists)
                {
                $p2_bullet_rect = new-object Drawing.Rectangle $p2_bullet_x, $p2_bullet_y, $p2_bullet_width, $p2_bullet_height
                $formGraphics.FillRectangle($p2_brush, $p2_bullet_rect) 
                }

                $player_1_rect = new-object Drawing.Rectangle $player1_x, $player1_y, $player_width, $player_height
                $formGraphics.FillRectangle($p1_brush, $player_1_rect) 




                if($p1_bullet_exists)
                {
                $p1_bullet_rect = new-object Drawing.Rectangle $p1_bullet_x, $p1_bullet_y, $p1_bullet_width, $p1_bullet_height
                $formGraphics.FillRectangle($p1_brush, $p1_bullet_rect) 
                }
                $wall1_left_rect = new-object Drawing.Rectangle  $wall1_left_x,  $wall1_left_y, $wall_type_1_width, $wall_type_1_height
                $formGraphics.FillRectangle($wall_brush, $wall1_left_rect)

                $wall1_right_rect = new-object Drawing.Rectangle  $wall1_right_x,  $wall1_right_y, $wall_type_1_width, $wall_type_1_height
                $formGraphics.FillRectangle($wall_brush, $wall1_right_rect)


                $wall2_left_rect = new-object Drawing.Rectangle  $wall2_left_x,  $wall2_left_y, $wall_type_1_width, $wall_type_1_height
                $formGraphics.FillRectangle($wall_brush, $wall2_left_rect)

                $wall2_right_rect = new-object Drawing.Rectangle  $wall2_right_x,  $wall2_right_y, $wall_type_1_width, $wall_type_1_height
                $formGraphics.FillRectangle($wall_brush, $wall2_right_rect)

                
                ## STAR
                $gravity_star_rect = new-object Drawing.Rectangle  $star_x, $star_y, $star_width, $star_height
                $formGraphics.FillEllipse($gravity_star_brush, $gravity_star_rect)
                $formGraphics.FillEllipse($gravity_star_brush, $gravity_star_rect)


            
              



            })
        
           


        
        # $p1hearts = ""
        # For ($i=0; $i -lt $player_1_hits; $i++) 
        # {       
        #     $p1hearts = $p1hearts + "♥" | set-content utf16
        # }

        # $p2name = "Player 2 "
        # For ($i=0; $i -lt $player_2_hits; $i++) 
        # { 
        #     $p2name = $p2name + $life
        # }
        # $p1Label.Text = $p1Label.Text + "p"
      


        $form.Controls.Add($dataPanel)
        $form.Refresh()
        $refresh = 0

    }


    ## IF ESC EXIT

    if (  ($API::GetAsyncKeyState(27)) ) {
        exit
    }

  

    #120 fps
    Start-Sleep -s (1 / 120)
} While ($gameOver -eq $false)

$retry = $false

while($retry -eq $false){



    if (  ($API::GetAsyncKeyState(27)) ) {
        exit
    }
    if (  ($API::GetAsyncKeyState(13)) ) {
        $retry = $true
        $form.Dispose()
    }
 
}


}while ($programExit -eq $false)
# }


