/**
 * This function checks for streaks takes the current letter, last letter and the current streak number as parameters
 * @param {Number} currentStreak
 * @param {String} lastLetter
 * @param {String} currentLetter
 * @returns data object with new streak & winningLetter
 */
function checkStreaks(currentStreak, lastLetter, currentLetter) {
  let winningLetter = null;

  if (currentLetter !== 'empty') {
    if (currentLetter === lastLetter) {
      currentStreak++; // incrementing the streak if the letter is same
    } else {
      currentStreak = 1; // resetting the streak if the letter is not same
    }
  }
  // checking if the player has won the game
  if (currentStreak === 3) {
    winningLetter = currentLetter;
  }

  return { streak: currentStreak, winningLetter };
}

/**
 * This function returns true if the room has any boxes remaning if not returns false
 * @param {String} roomId id of the room
 * @returns true if the room has any boxes remaning if not false
 */
function boxesRemaning(boxes) {
  let empty = false;
  for (let i = 0; i < 3; i++) {
    for (let j = 0; j < 3; j++) {
      let box = boxes[i][j];
      if (box === 'empty') {
        empty = true;
      }
    }
  }
  return empty;
}

/**
 * Checks if there are any 3 streaks in the boxes & if yes returns the winning letter
 * @param {Array} boxes boxes
 * @returns  winning letter
 */
function checkWin(boxes) {
  let verticalStreak = 1;
  let lastVerticalLetter = null;

  let horizontalStreak = 1;
  let lastHorizontalLetter = null;

  let diagonalStreak = 1;
  let lastDiagonalLetter;

  let winningLetter = null;

  // iterating through the boxes to check for streaks
  for (let i = 0; i < 3 && winningLetter == null; i++) {
    for (let j = 0; j < 3; j++) {
      let currentLetter = boxes[i][j]; // letter on the current X & Y positions
      let verticalBox = boxes[j - 1];

      let currentVerticalLetter = boxes[j][i];

      if (verticalBox) {
        lastVerticalLetter = verticalBox[i];
      }

      if (i == j) {
        // checking for diagonal streak
        // putting the if statement because diagonal point is where X & Y positions match!
        let diagonalStreakData = checkStreaks(
          diagonalStreak,
          lastDiagonalLetter,
          currentLetter
        );
        diagonalStreak = diagonalStreakData.streak;
        winningLetter = diagonalStreakData.winningLetter;
        lastDiagonalLetter = currentLetter;
        if (winningLetter) break;
      }

      // checking for horizontal streak
      let horizontalStreakData = checkStreaks(
        horizontalStreak,
        lastHorizontalLetter,
        currentLetter
      );
      horizontalStreak = horizontalStreakData.streak;
      winningLetter = horizontalStreakData.winningLetter;
      if (winningLetter != null) break;

      // checking for vertical streak
      let verticalStreakData = checkStreaks(
        verticalStreak,
        lastVerticalLetter,
        currentVerticalLetter
      );
      verticalStreak = verticalStreakData.streak;
      winningLetter = verticalStreakData.winningLetter;
      if (winningLetter != null) break;

      lastHorizontalLetter = currentLetter;
    }
  }

  return winningLetter;
}

/**
 * This method generates an array of boxes with their positions and letters
 * @returns array of boxes
 */
function generateBoxes() {
  let boxes = [];
  for (let i = 0; i < 3; i++) {
    let row = [];
    for (let j = 0; j < 3; j++) {
      row.push('empty');
    }
    boxes.push(row);
  }
  return boxes;
}

module.exports = { generateBoxes, checkWin, boxesRemaning, checkStreaks };
