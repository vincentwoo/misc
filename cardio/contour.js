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
  
  var interval = 15;
  var max = -Infinity, min = Infinity;
  var canvas = document.getElementById('canvas');
  var ctx = canvas.getContext('2d');
  var segs = [
    [],                                       // 0, no contour
    [{s1: 'L', s2: 'B'}],                     // 1
    [{s1: 'R', s2: 'B'}],                     // 2
    [{s1: 'L', s2: 'R'}],                     // 3
    [{s1: 'T', s2: 'R'}],                     // 4
    [{s1: 'L', s2: 'T'}, {s1: 'B', s2: 'R'}], // 5, saddle
    [{s1: 'B', s2: 'T'}],                     // 6
    [{s1: 'L', s2: 'T'}],                     // 7
    [{s1: 'L', s2: 'T'}],                     // 8
    [{s1: 'B', s2: 'T'}],                     // 9
    [{s1: 'L', s2: 'B'}, {s1: 'T', s2: 'R'}], // 10, saddle
    [{s1: 'T', s2: 'R'}],                     // 11
    [{s1: 'L', s2: 'R'}],                     // 12
    [{s1: 'R', s2: 'B'}],                     // 13
    [{s1: 'L', s2: 'B'}],                     // 14
    [],                                       // 15, no contour
  ];
  
  // make these global so I don't have to think about them
  var data;
  var threshold;
  
  function parse(text) {
    data = text.split('\n').map( function(line) {
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
    for (threshold = min; threshold <= max; threshold += interval) {
      marching_squares(data.map (function(row) {
        return row.map (function(val) {
          return (val > threshold) ? 0 : 1; // flipped, 0 if above
        });
      }));
    }
  }

  function marching_squares(filtered, threshold) {
    var rows = filtered.length - 1;
    var cols = filtered[0].length - 1;
    
    var cells = new Array(rows);
    for (var i = 0; i < rows; i++) {
      cells[i] = new Array(cols);
      for (var j = 0; j < cols; j++) {
        // remember: cells stored in [row][col], or [y][x]
        var TL = filtered[i][j];
        var TR = filtered[i][j+1];
        var BL = filtered[i+1][j];
        var BR = filtered[i+1][j+1];
        cells[i][j] = 8 * TL + 4 * TR + 2 * BR + BL;
      }
    }
    draw(cells);
  }
  
  function interp(a, b) {
    return (threshold - a) / (b - a);
  }
  
  function pointForSide(row, col, side) {
    var x, y;
    switch (side) {
      case 'B':
        y = 1;
        x = interp(data[row+1][col], data[row+1][col+1]);
        break;
      case 'T':
        y = 0;
        x = interp(data[row][col], data[row][col+1]);
        break;
      case 'L':
        x = 0;
        y = interp(data[row][col], data[row+1][col]);
        break;
      case 'R':
         x = 1;
         y = interp(data[row][col+1], data[row+1][col+1]);
         break;
    }
    return {x: x, y: y};
  }
  
  function draw(cells) {
    for (var row = 0; row < cells.length; row++) {
      for (var col = 0; col < cells[0].length; col++) {
        segs[cells[row][col]].forEach( function(seg) {
          var p1 = pointForSide(row, col, seg.s1);
          var p2 = pointForSide(row, col, seg.s2);
          ctx.beginPath();
          ctx.moveTo(col * 30 + p1.x * 30, row * 30 + p1.y * 30);
          ctx.lineTo(col * 30 + p2.x * 30, row * 30 + p2.y * 30);
          ctx.stroke();
          ctx.closePath();
        });
      }
    }
  }
});