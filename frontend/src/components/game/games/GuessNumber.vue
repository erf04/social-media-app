<template>
  <div>
    <p id="message">Guess, my sagi friend!</p>
    <p class="hint">
      hint: <span style="color: blue">try up</span>
      <span style="color: red">try down</span>
      <span style="color: green">match</span>
    </p>
    <button id="check_sagi">Start</button> <br />
    <button id="another_nums">Change numbers</button>
    <ul id="answers">
      <li class="answer"></li>
      <li class="answer"></li>
      <li class="answer"></li>
      <li class="answer"></li>
      <li class="answer"></li>
    </ul>
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
    scoreboard & new_player ...
    print reset counts (after win text)
    background & display champion cup after winner:
        const img = document.createElement("img");
        img.src = "https://picsum.photos/200/301";
*/

      const button1 = document.getElementById("check_sagi");
      const button2 = document.getElementById("another_nums");
      button1.addEventListener("click", button_click1);
      button2.addEventListener("click", button_click2);
      let change_nums = document.getElementById("another_nums");
      cursor(0);
      // let body = document.getElementsByName("body");
      const container = document.getElementsByTagName("div")[0];
      let answers = [];
      let count = 0;
      var rst_count = 0;
      for (let j = 0; j < 5; j++) answers[j] = Math.floor(Math.random() * 10);

      function button_click1(event) {
        if (event.target.innerHTML === "Check combo") {
          check(answers);
        } else if (event.target.innerHTML === "Restart") {
          event.target.innerHTML = "Check combo";
          fill_again();
        } else {
          cursor(1);
          event.target.innerHTML = "Check combo";
          input_maker();
        }
      }

      function button_click2(rst_count) {
        if (change_nums.style.cursor !== "not-allowed") {
          fill_again();
          rst_count++;
        }
        return rst_count;
      }
      rst_count = button_click2(rst_count);

      function cursor(ability) {
        if (ability) {
          change_nums.style.cursor = "default";
          change_nums.style.opacity = "1";
        } else {
          change_nums.style.cursor = "not-allowed";
          change_nums.style.opacity = "0.6";
        }
      }

      function input_maker() {
        let input;
        let rand_num;
        for (let i = 0; i < 5; i++) {
          input = document.createElement("input");
          rand_num = Math.floor(Math.random() * 10);
          input.setAttribute("type", "number");
          input.max = 9;
          input.min = 0;
          input.size = 1;
          input.style.width = "50px";
          input.style.height = "50px";
          input.style.textAlign = "center";
          input.style.fontSize = "3em";
          input.style.width = "100px";
          input.style.height = "100px";
          input.classList.add("num");
          input.value = rand_num;
          input.order = 1;
          container.appendChild(input);
        }
      }

      function check(answers) {
        let flag1 = false,
            flag2 = false,
            flag3 = false;
        let elements = document.getElementsByClassName("num");
        for (let i = 0; i < 5; i++) {
          elements[i].style.width = "100px";
          elements[i].style.height = "100px";
          if (elements[i].value == answers[i]) {
            elements[i].style.background = "green";
            flag1 = true;
          } else if (elements[i].value < answers[i]) {
            elements[i].style.background = "blue";
            flag2 = true;
          } else {
            elements[i].style.background = "red";
            flag3 = true;
          }
        }
        count++;

        if (flag1 && !flag2 && !flag3) {
          let win_text = document.createElement("p");
          win_text.innerHTML = `You're the winner sagi!
        \nYou could win in ${count} times.\n`;
          win_text.style.fontSize = "36px";
          win_text.style.fontFamily = "tahoma";
          win_text.style.color = "black";
          win_text.style.background = "yellow";
          win_text.style.marginTop = "100px";
          win_text.classList.add("win_text");
          container.appendChild(win_text);

          let rst_time_text = document.createElement("p");
          rst_time_text.innerHTML = `You changed numbers
        ${rst_count} times.`;
          rst_time_text.style.fontSize = "36px";
          rst_time_text.style.fontFamily = "tahoma";
          rst_time_text.style.color = "black";
          rst_time_text.style.background = "yellow";
          rst_time_text.classList.add("rst_time_text");
          container.appendChild(rst_time_text);

          document.getElementById("check_sagi").innerHTML = "Restart";
          cursor(0);
        }
      }

      function fill_again() {
        count = 0;
        let elements = document.getElementsByClassName("num");
        let rand_num, answer_num;
        for (let i = 0; i < 5; i++) {
          rand_num = Math.floor(Math.random() * 10);
          answer_num = Math.floor(Math.random() * 10);
          elements[i].value = rand_num;
          answers[i] = answer_num;
          elements[i].style.background = "white";
        }

        let win_text = document.getElementsByClassName("win_text")[0];
        container.removeChild(win_text);
        let rst_time_text = document.getElementsByClassName("rst_time_text")[0];
        container.removeChild(rst_time_text);
        cursor(1);
      }

    }
  }
}
</script>

<style scoped>
.answer {
  font-family: tahoma;
  font-weight: bold;
  display: inline-block;
  margin-left: 0;
  padding: 0 7px;
  font-size: medium;
}

* {
  padding: 0;
  margin: 0;
}

body {
  background: rgb(0, 0, 0);
  background: linear-gradient(-45deg, rgba(0, 0, 0, 1) 0%, rgba(3, 0, 255, 1) 0%, rgba(11, 11, 11, 1) 58%);
  height: 100vh;
}

button {
  font-family: tahoma;
  background-color: #e7e7e7;
  border: none;
  border-radius: 20px;
  color: black;
  padding: 12px 25px;
  text-align: center;
  font-size: 24px;
  margin-top: 50px;
  margin-bottom: 70px;
  transition-duration: 0.4s;
}

button:hover {
  background-color: #4CAF50;
  color: white;
  box-shadow: 0 12px 16px 0 rgba(0, 0, 0, 0.24), 0 17px 50px 0 rgba(0, 0, 0, 0.19);
}

#check_sagi {
  margin-bottom: 0px;
}

#another_nums {
  background-color: black;
  color: darkgoldenrod;
  margin-top: 5px;
  padding: 7px;
  font-size: 10px;
}

span {
  margin-left: 10px;
}

.hint {
  color: white;
  font-family: tahoma;
  font-size: 18px;
  margin-top: 50px;
}

div {
  text-align: center;
}

image {
  width: 50px;
  height: 50px;
}

#message {
  text-align: center;
  font-family: tahoma;
  font-size: 24px;
  color: navy;
  background-color: white;
}
</style>