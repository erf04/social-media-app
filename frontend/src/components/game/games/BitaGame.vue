<template>
  <button type="submit" id="add">Add Player</button>
  <br />
  <input type="text" id="playerName" />
  <button type="submit" id="begin">Start</button>
  <p id="name">Player Name:&nbsp;</p>
  <p id="score">Score:&nbsp;</p>
  <div id="container">
    <img shape="circle" src="bita_sagi.jpg" id="runner" />
  </div>
</template>

<script>

export default {
  data() {
    return {
    }
  },
  methods: {
    main() {
      /*
  score
  controling keypress
*/

//DOM
      var block;
      var runner = document.getElementById("runner");
      var begin_button = document.getElementById("begin");
      var container = document.getElementById("container");
      var addbtn = document.getElementById("add");
      var playerName = document.getElementById("playerName");

//set sizes
      var container_width = container.clientWidth;
      var block_width = 40;
      var block_height = 40;
      var runner_width = runner.clientWidth;

//calculations
      var block_pos,
          x,
          checking,
          flag,
          audio = new Audio("bita_sagi_chagh.m4a"),
          flag1 = true;

      begin_button.disabled = true;
      begin_button.style.cursor = "not-allowed";

      addbtn.addEventListener("click", add);

      begin_button.addEventListener("click", start);
      document.addEventListener("keypress", function (e) {
        if (e.keyCode == 13 && begin_button.disabled === false) start();
      });

      function add() {
        begin_button.disabled = true;
        begin_button.style.cursor = "not-allowed";
        Name.innerHTML = "Player Name: ";
        score.innerHTML = "Score: ";
        playerName.style.display = "block";
        if (playerName.value !== "")
          submit();
        else if (addbtn.innerHTML==="Submit" && playerName.value === ""){
          alert("type the sagi player name!");
        }
        addbtn.innerHTML = "Submit";
      }

      var Name = document.getElementById("name");
      var score = document.getElementById("score");
      var block_jump = 0;
      function submit() {
        Name.innerHTML += playerName.value;
        score.innerHTML += block_jump;
        begin_button.disabled = false;
        begin_button.style.cursor = "pointer";
        begin_button.innerHTML = "Start";
        playerName.value = "";
        playerName.style.display = "none";
        addbtn.innerHTML = "Add Player";
      }

      function start() {
        audio.pause();
        audio.currentTime = 0;
        flag1 = true;
        flag = true;
        begin_button.style.cursor = "not-allowed";
        begin_button.disabled = true;
        runner.style.top = "0";
        if (block) container.removeChild(block);
        set_pre_block_pos();
        x = setInterval(block_move, 0.5);
        checking = setInterval(check, 0.5);
      }

      var jumping_up, jumping_down;
      document.addEventListener("keypress", function (ev) {
        if (ev.keyCode == 32) {
          if (flag && runner_pos === 0) jumping_up = setInterval(jump_up, 1);
        }
      });

      var runner_pos = 0;

      function jump_up() {
        if (runner_pos === -(block_width + 50)) {
          clearInterval(jumping_up);
          jumping_down = setInterval(jump_down, 1);
        } else if (flag1) {
          runner_pos--;
          runner.style.top = runner_pos + "px";
        }
      }

      function jump_down() {
        if (runner_pos === 0) {
          clearInterval(jumping_down);
        } else if (flag1) {
          runner_pos++;
          runner.style.top = runner_pos + "px";
        }
      }

      function check() {
        if (
            runner_pos <= 0 &&
            runner_pos >= -block_height &&
            block_pos <=
            -(
                container_width -
                20 -
                block_width -
                runner_width +
                calculate_x(runner_width / 2, runner_pos)
            )
        ) {
          block_jump = 0;
          flag1 = false;
          audio.play();
          clearInterval(checking);
          clearInterval(x);
          clearInterval(jumping_up);
          clearInterval(jumping_down);
          runner_pos = 0;

          flag = false;
          begin_button.innerHTML = "Restart";
          begin_button.disabled = false;
          begin_button.style.cursor = "pointer";
        }
      }

      function appear_block_pic(img) {
        score.innerHTML = "Score: " + block_jump;
        block_jump++;
        let index = Math.floor(Math.random() * 3);
        if (index === 0) {
          img.src = "burger.jpg";
          block_height = 40;
        } else if (index === 1) {
          img.src = "pizza.png";
          block_height = 45;
          img.style.height = 45 + "px";
          img.style.marginTop = 155 + "px";
        } else {
          img.src = "shake.jpg";
          img.style.height = 50 + "px";
          img.style.marginTop = 150 + "px";
          block_height = 50;
        }
        return img;
      }

      function block_move() {
        if (block_pos === -(container_width - block_width)) {
          block_pos = 0;
          container.removeChild(block);
          for (let i = 0; i < 1; i++) set_pre_block_pos();
        } else {
          block_pos--;
          block.style.left = block_pos + "px";
        }
      }

      function set_pre_block_pos() {
        let middle = container_width / 2;
        let pos = -Math.floor(Math.random() * middle);
        block = document.createElement("img");
        block.classList.add("block");
        block.style.left = pos + "px";
        block = appear_block_pic(block);
        container.appendChild(block);
        block_pos = pos;
      }

      function calculate_x(r, jump) {
        var y;
        if (jump >= -(block_height - r)) y = 0;
        else y = r - jump - block_height;
        let square = Math.pow(r, 2) - Math.pow(y, 2);
        return r - Math.pow(square, 0.5);
      }
    }
  }
}

</script>

<style scoped>
html {
  background: #223;
  display: grid;
  place-items: center;
}

p {
  display: block;
  font-family: cursive;
  margin-bottom: 0;
}

#score {
  color: rgb(255, 204, 0);
}

#name {
  color: aqua;
}

#container {
  background-color: white;
  border-style: inset;
  border-color: rgb(0, 95, 28);
  border-width: 10px;
  width: 500px;
  height: 200px;
  position: absolute;
  margin-left: -210px;
}

.block {
  padding: 0;
  position: absolute;
  width: 40px;
  height: 40px;
  margin-top: 160px;
  margin-left: 460px;
}

#runner {
  padding: 0;
  position: absolute;
  width: 60px;
  height: 60px;
  margin-top: 139px;
  margin-right: 450px;
  margin-left: 20px;
  border-radius: 100%;
}

#add {
  font-family: cursive;
  display: block;
  margin-top: 70px;
  top: 50%;
  background-color: #0a0a23;
  color: #fff;
  border-radius: 10px;
  padding: 15px;
  min-height: 30px;
  min-width: 120px;
  transition: 0.7s;

}

#add:hover {
  outline-color: transparent;
  outline-style: solid;
  box-shadow: 0 0 0 4px #5a01a7;
  cursor: pointer;
}

#add:active {
  background-color: #ffbf00;
}

#begin {
  font-family: cursive;
  display: block;
  margin-top: 80px;
  margin-bottom: 100px;
  top: 50%;
  background-color: #0a0a23;
  color: #fff;
  border-radius: 10px;
  padding: 15px;
  min-height: 30px;
  min-width: 120px;
  transition: 0.7s;
}

#begin:hover {
  outline-color: transparent;
  outline-style: solid;
  box-shadow: 0 0 0 4px #5a01a7;
  cursor: pointer;
}

#begin:active {
  background-color: #ffbf00;
}

#playerName {
  margin-right: 0;
  margin-bottom: 0;
  font-size: large;
  font-family: cursive;
  text-align: center;
  display: none;
  margin-top: 20px;
  margin-left: -60px;
}
</style>