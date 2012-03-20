var data = [[0, 10, 0],
            [10, 20, 10],
            [0, 10, 0]];
var interval = 5;
var max = -Infinity, min = Infinity;
var canvas = document.getElementById('canvas');

console.log(canvas);

data.forEach (function(row) {
  row.forEach (function(val) {
    if (val > max) max = val;
    if (val < min) min = val;
  });
});

for (var threshold = min; threshold < max; threshold += interval) {
  marching_squares(data.map (function(row) {
    return row.map (function(val) {
      return (val > threshold) ? 1 : 0;
    });
  }));
}

function marching_squares(filtered) {
  
}