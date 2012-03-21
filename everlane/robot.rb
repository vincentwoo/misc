def go
  if rock?
    pick
    go
    move
  end
end
go