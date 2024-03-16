<template @keyup.enter="start" @keyup.space="jumping_up = setInterval(jump_up, 1)">
  <button @click="add" type="submit" id="add">Add Player</button>
  <br />
  <input type="text" id="playerName" />
  <button @click="start" type="submit" id="begin">Start</button>
  <p id="name">Player Name:&nbsp;</p>
  <p id="score">Score:&nbsp;</p>
  <div id="container">
    <img shape="circle" src="../../../assets/bita/bita_sagi.jpg" id="runner" />
  </div>
</template>

<script>

export default {
  data() {
    return {
      begin_button: null,
      Name: '',
      score: 0,
      playerName: null,
      addbtn: null,
      audio: null,
      block_jump: 0,
      flag: false,
      flag1: true,
      runner: null,
      block: null,
      container: null,
      block_width: 40,
      block_height: 40,
      block_pos: null,
      x: null,
      checking: null,
      jumping_up: null,
      jumping_down: null,
      runner_width: 0,
      runner_pos: 0,
      container_width: 0,
    }
  },
  methods: {
    add() {
      this.begin_button.disabled = true;
      this.begin_button.style.cursor = "not-allowed";
      this.Name.innerHTML = "Player Name: ";
      this.score.innerHTML = "Score: ";
      this.playerName.style.display = "block";
      if (this.playerName.value !== "")
        this.submit();
      else if (this.addbtn.innerHTML==="Submit" && this.playerName.value === ""){
        alert("type the sagi player name!");
      }
      this.addbtn.innerHTML = "Submit";
    },
    submit() {
      this.Name.innerHTML += this.playerName.value;
      this.score.innerHTML += this.block_jump;
      this.begin_button.disabled = false;
      this.begin_button.style.cursor = "pointer";
      this.begin_button.innerHTML = "Start";
      this.playerName.value = "";
      this.playerName.style.display = "none";
      this.addbtn.innerHTML = "Add Player";
    },
    start() {
      this.audio.pause();
      this.audio.currentTime = 0;
      this.flag1 = true;
      this.flag = true;
      this.begin_button.style.cursor = "not-allowed";
      this.begin_button.disabled = true;
      this.runner.style.top = "0";
      if (this.block) this.container.removeChild(this.block);
      this.set_pre_block_pos();
      this.x = setInterval(this.block_move, 0.5);
      this.checking = setInterval(this.check, 0.5);
    },
    jump_up() {
      if (this.runner_pos === -(this.block_width + 50)) {
        clearInterval(this.jumping_up);
        this.jumping_down = setInterval(this.jump_down, 1);
      } else if (this.flag1) {
        this.runner_pos--;
        this.runner.style.top = this.runner_pos + "px";
      }
    },
    jump_down() {
      if (this.runner_pos === 0) {
        clearInterval(this.jumping_down);
      } else if (this.flag1) {
        this.runner_pos++;
        this.runner.style.top = this.runner_pos + "px";
      }
    },
    check() {
      if (
          this.runner_pos <= 0 &&
          this.runner_pos >= -this.block_height &&
          this.block_pos <=
          -(
              this.container_width -
              20 -
              this.block_width -
              this.runner_width +
              this.calculate_x(this.runner_width / 2, this.runner_pos)
          )
      ) {
        this.block_jump = 0;
        this.flag1 = false;
        this.audio.play();
        clearInterval(this.checking);
        clearInterval(this.x);
        clearInterval(this.jumping_up);
        clearInterval(this.jumping_down);
        this.runner_pos = 0;

        this.flag = false;
        this.begin_button.innerHTML = "Restart";
        this.begin_button.disabled = false;
        this.begin_button.style.cursor = "pointer";
      }
    },
    appear_block_pic(img) {
      this.score.innerHTML = "Score: " + this.block_jump;
      this.block_jump++;
      let index = Math.floor(Math.random() * 3);
      if (index === 0) {
        img.src = "../../../assets/bita/burger.jpg";
        this.block_height = 40;
      } else if (index === 1) {
        img.src = "../../../assets/bita/pizza.png";
        this.block_height = 45;
        img.style.height = 45 + "px";
        img.style.marginTop = 155 + "px";
      } else {
        img.src = "../../../assets/bita/shake.jpg";
        img.style.height = 50 + "px";
        img.style.marginTop = 150 + "px";
        this.block_height = 50;
      }
      return img;
    },
    block_move() {
      if (this.block_pos === -(this.container_width - this.block_width)) {
        this.block_pos = 0;
        this.container.removeChild(this.block);
        for (let i = 0; i < 1; i++) this.set_pre_block_pos();
      } else {
        this.block_pos--;
        this.block.style.left = this.block_pos + "px";
      }
    },
    set_pre_block_pos() {
      let middle = this.container_width / 2;
      let pos = -Math.floor(Math.random() * middle);
      this.block = document.createElement("img");
      this.block.classList.add("block");
      this.block.style.left = pos + "px";
      this.block = this.appear_block_pic(this.block);
      this.container.appendChild(this.block);
      this.block_pos = pos;
    },
    calculate_x(r, jump) {
      var y;
      if (jump >= -(this.block_height - r)) y = 0;
      else y = r - jump - this.block_height;
      let square = Math.pow(r, 2) - Math.pow(y, 2);
      return r - Math.pow(square, 0.5);
    }
  },
  mounted() {
    // eslint-disable-next-line no-unused-vars
    this.runner = document.getElementById("runner");
    // eslint-disable-next-line no-unused-vars
    this.begin_button = document.getElementById("begin");
    // eslint-disable-next-line no-unused-vars
    this.container = document.getElementById("container");
    // eslint-disable-next-line no-unused-vars
    this.addbtn = document.getElementById("add");
    // eslint-disable-next-line no-unused-vars
    this.playerName = document.getElementById("playerName");
    this.container_width = this.container.clientWidth;
    this.runner_width = this.runner.clientWidth;
    this.audio = new Audio("../../../assets/bita/bita_sagi_chagh.m4a");
    console.log(this.audio);
    this.begin_button.disabled = true;
    this.begin_button.style.cursor = "not-allowed";
    this.Name = document.getElementById("name");
    this.score = document.getElementById("score");
    this.block_jump = 0;
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