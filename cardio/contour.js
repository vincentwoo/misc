window.addEventListener('load', function() {
  
  window.addEventListener('drop', function(evt) {
    evt.stopPropagation();
    evt.preventDefault();
    var file = evt.dataTransfer.files[0];
    reader = new FileReader();
    reader.onloadend = function(e) {
    console.log(e);
      parse(e.target.result);
    }
    reader.readAsText(file);
  });
  
  var interval = 1;
  var max = -Infinity, min = Infinity;
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  var segs = [
    [],                                       // 0, no contour
    [{x1: 0,   y1: 0.5, x2: 0.5, y2: 1}],     // 1
    [{x1: 0.5, y1: 1,   x2: 1,   y2: 0.5}],   // 2
    [{x1: 0,   y1: 0.5, x2: 1,   y2: 0.5}],   // 3
    [{x1: 0.5, y1: 0,   x2: 1,   y2: 0.5}],   // 4
    [{x1: 0.5, y1: 1,   x2: 1,   y2: 0.5},    // 5, saddle
     {x1: 0,   y1: 0.5, x2: 0.5, y2: 0}],
    [{x1: 0.5, y1: 0,   x2: 0.5, y2: 1}],     // 6
    [{x1: 0,   y1: 0.5, x2: 0.5, y2: 0}],     // 7
    [{x1: 0,   y1: 0.5, x2: 0.5, y2: 0}],     // 8
    [{x1: 0.5, y1: 0,   x2: 0.5, y2: 1}],     // 9
    [{x1: 0.5, y1: 0,   x2: 1,   y2: 0.5},    // 10, saddle
     {x1: 0,   y1: 0.5, x2: 0.5, y2: 1}],
    [{x1: 0.5, y1: 0,   x2: 1,   y2: 0.5}],   // 11
    [{x1: 0,   y1: 0.5, x2: 1,   y2: 0.5}],   // 12
    [{x1: 0.5, y1: 1,   x2: 1,   y2: 0.5}],   // 13
    [{x1: 0,   y1: 0.5, x2: 0.5, y2: 1}],     // 14
    [],                                       // 15, no contour
  ];
  
  function parse(text) {
    var data = text.split('\n').map( function(line) {
      return line.split('\t').map(parseFloat);
    });
    console.log(data);
  
    data.forEach (function(row) {
      row.forEach (function(val) {
        if (val > max) max = val;
        if (val < min) min = val;
      });
    });

    ctx.clearRect(0, 0, 500, 350);
    for (var threshold = min; threshold <= max; threshold += interval) {
      marching_squares(data.map (function(row) {
        return row.map (function(val) {
          return (val > threshold) ? 0 : 1; // flipped, 0 if above
        });
      }));
    }
  }

  function marching_squares(filtered) {
    var rows = filtered.length - 1;
    var cols = filtered[0].length - 1;
    
    var cells = new Array(rows);
    for (var i = 0; i < rows; i++) {
      cells[i] = new Array(cols);
      for (var j = 0; j < cols; j++) {
        var TL = filtered[i][j];
        var TR = filtered[i+1][j];
        var BL = filtered[i][j+1];
        var BR = filtered[i+1][j+1];
        cells[i][j] = 8 * TL + 4 * TR + 2 * BR + BL;
      }
    }
    draw(cells);
  }
  
  function draw(cells) {
    ctx.strokeStyle = "red";
    for (var i = 0; i < cells.length; i++) {
      for (var j = 0; j < cells[0].length; j++) {
        for (var lineno = 0; lineno < segs[cells[i][j]].length; lineno++) {
          var seg = segs[cells[i][j]][lineno];
          ctx.beginPath();
          ctx.moveTo(i * 30 + seg.x1 * 30, j * 30 + seg.y1 * 30);
          ctx.lineTo(i * 30 + seg.x2 * 30, j * 30 + seg.y2 * 30);
          ctx.stroke();
          ctx.closePath();
        }
      }
    }
  }
});