const assert = require('assert');

const {
  generateBoxes,
  checkWin,
  checkStreaks,
  boxesRemaning,
} = require('../src/controllers/Game.js');

describe('GameLogic', function () {
  describe('#generateBoxes()', function () {
    it('should return array with objects of boxes with their position & the letter inside them', function () {
      let expectedArray = [
        ['empty', 'empty', 'empty'],
        ['empty', 'empty', 'empty'],
        ['empty', 'empty', 'empty'],
      ].toString();
      let actualArray = generateBoxes().toString();

      assert.equal(expectedArray, actualArray);
    });
  });
  describe('#checkStreaks()', function () {
    it('should return streak Data object containing the winning letter if any and the streak number after operating on both of the values with the provided arguments', function () {
      // test case 1
      let expectedObject = { streak: 2, winningLetter: null };
      let actualObject = checkStreaks(1, 'X', 'X');

      assert.equal(actualObject.streak, expectedObject.streak);
      assert.equal(actualObject.winningLetter, expectedObject.winningLetter);

      // test case 2
      expectedObject = { streak: 3, winningLetter: 'O' };
      actualObject = checkStreaks(2, 'O', 'O');

      assert.equal(actualObject.streak, expectedObject.streak);
      assert.equal(actualObject.winningLetter, expectedObject.winningLetter);
    });
  });
  describe('#checkWin()', function () {
    it('should return true if the boxes have a streak', function () {
      // test case 1
      let boxes = [
        ['X', 'empty', 'empty'],
        ['empty', 'X', 'empty'],
        ['empty', 'O', 'empty'],
      ];
      assert.equal(checkWin(boxes), null);

      // test case 2
      boxes = [
        ['X', 'X', 'X'],
        ['empty', 'empty', 'empty'],
        ['empty', 'O', 'empty'],
      ];
      assert.equal(checkWin(boxes), 'X');

      // test case 3
      boxes = [
        ['X', 'X', 'O'],
        ['empty', 'empty', 'O'],
        ['empty', 'empty', 'O'],
      ];
      assert.equal(checkWin(boxes), 'O');

      //  test case 4
      boxes = [
        ['X', 'X', 'empty'],
        ['empty', 'X', 'empty'],
        ['O', 'X', 'O'],
      ];
      assert.equal(checkWin(boxes), 'X');

      // test case 5
      boxes = [
        ['X', 'O', 'empty'],
        ['O', 'empty', 'empty'],
        ['O', 'empty', 'empty'],
      ];
      assert.equal(checkWin(boxes), null);

      // test case 6
      boxes = [
        ['X', 'X', 'O'],
        ['empty', 'empty', 'X'],
        ['empty', 'empty', 'empty'],
      ];
      assert.equal(checkWin(boxes), null);
    });
  });
  describe('#boxesRemaning()', function () {
    it('should return true if the boxes array in the arguments have any empty boxes if not should return false', function () {
      // test case 1
      let boxes = [
        ['X', 'X', 'empty'],
        ['O', 'X', 'X'],
        ['X', 'O', 'X'],
      ];
      assert.equal(boxesRemaning(boxes), true);

      // test case 2
      boxes = [
        ['X', 'O', 'X'],
        ['X', 'X', 'O'],
        ['O', 'X', 'X'],
      ];
      assert.equal(boxesRemaning(boxes), false);
    });
  });
});
