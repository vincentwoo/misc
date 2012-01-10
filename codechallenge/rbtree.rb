class RBNode
  attr_accessor :color, :data, :links
  
  def initialize(data)
    @color = :red
    @links = {}
    @links[:left] = @links[:right] = nil
    @data = data
  end
  
  def left
    links[:left]
  end
  
  def right
    links[:right]
  end
  
  def self.red?(node)
    !node.nil? and node.color == :red
  end
  
  def self.opp(dir)
    dir == :left ? :right : :left
  end
end

class RBTree
  attr_accessor :root
  def initialize data
    @root = RBNode.new data
    @root.color = :black
  end
  
  def single_rotate(root, dir)
    opp = RBNode.opp dir
    
    save = root.links[opp]
    
    root.links[opp] = save.links[dir]
    save.links[dir] = root
    
    root.color = :red
    save.color = :black
    
    save
  end
  
  def double_rotate(root, dir)
    opp = RBNode.opp dir
    
    root.links[opp] = self.single_rotate root.links[opp], opp
    single_rotate root, dir
  end
  
  def insert(data)
    @root = insert_recursive(@root, data)
    @root.color = :black
  end
  
  def insert_recursive(root, data)
    if root.nil?
      root = RBNode.new data
    elsif root.data != data
      dir = root.data < data ? :right : :left
      opp = RBNode.opp dir
      root.links[dir] = insert_recursive root.links[dir], data
      
      if RBNode.red? root.links[dir]
        if RBNode.red? root.links[opp]
          root.color = :red
          root.left.color = root.right.color = :black
        else
          if RBNode.red? root.links[dir].links[dir]
            root = single_rotate root, opp
          elsif RBNode.red? root.links[dir].links[opp]
            root = double_rotate root, opp
          end
        end
      end
    end
    
    root
  end
  
  def remove(data)
    @root = remove_recursive(@root, data)
    @root.color = :black unless @root.nil?
  end
  
  def remove_balance(root, dir, done)
    opp = RBNode.opp dir
    p = root
    s = root.links[opp]
    
    if !s.nil? and !RBNode.red?(s)
      if !RBNode.red?(s.left) and !RBNode.red?(s.right)
        done[0] = true if RBNode.red? p
        p.color = :black
        s.color = :red
      else
        save = root.color
        
        if RBNode.red? s.links[opp]
          p = single_rotate p, dir
        else
          p = double_rotate p, dir
        end
        
        p.color = save
        p.left.color = p.right.color = :black
        done[0] = true
      end
    elsif !s.links[dir].nil?
      r = s.links[dir]
      
      if !RBNode.red?(r.left) and !RBNode.red?(r.right)
        p = single_rotate p, dir
        p.links[dir].links[opp].color = :red
      else
        s.links[dir] = single_rotate(r, opp) if RBNode.red? r.links[dir]
        p = double_rotate p, dir
        s.links[dir].color = :black
        s.links[opp].color = :red
      end
      
      p.color = p.links[dir].color = :black
      done[0] = true
    end
    p
  end
  
  def remove_recursive(root, data, done = [false])
    root = @root
    if root.nil?
      done[0] = true
    else
      if root.data == data
        if root.left.nil? or root.right.nil?
          save = root.left.nil? ? root.right : root.left
          if RBNode.red? root
            done[0] = true
          elsif RBNode.red? save
            save.color = :black
            done[0] = true
          end
          
          return save
        else
          heir = root.left
          until heir.right.nil?
            heir = heir.right
          end
          root.data = heir.data
          data = heir.data
        end
      end
      
      dir = root.data < data ? :right : :left
      p root.data
      root.links[dir] = remove_recursive root.links[dir], data, done
      
      root = remove_balance(root, dir, done) unless done[0]
    end
    root
  end
  
  def assert
    assert_recursive @root
  end
  
  def assert_recursive(root)
    return 1 if root.nil?
    if RBNode.red?(root) and (RBNode.red?(root.left) or RBNode.red?(root.right))
      puts "red violation"
      return 0
    end
    
    if (!root.left.nil? and root.left.data >= root.data) or
        (!root.right.nil? and root.right.data <= root.data)
      puts "btree violation"
      return 0
    end
    
    lh = assert_recursive root.left
    rh = assert_recursive root.right
    
    if lh != 0 and rh != 0 and lh != rh
      puts "black violation"
      return 0
    end
    
    if lh != 0 and rh != 0
      return RBNode.red?(root) ? lh : lh + 1
    else
      return 0
    end
  end
end

tree = RBTree.new 5
tree.insert 6
tree.insert 7
tree.insert 8
tree.insert 9
tree.insert 10
tree.insert 11
tree.insert 4
tree.insert 3
tree.remove 7
p tree.assert