#require './node'

# Use TomDOC to document
class Graph
  attr_accessor :score_matrix, :node_names, :nodes, :edges

  def initialize(node_names, score_matrix)
    @node_names = node_names
    @score_matrix = score_matrix

    @nodes = {}
    add_nodes
    connect_nodes
  end

  def diagonal
    score_matrix.each(:diagonal).to_a
  end

  def pack_node_data
    node_scores = diagonal
    node_names.zip(node_scores)
  end

  def create_nodes
    node_data = pack_node_data
    node_data.map { |item| Node.new(name = item[0], weight = item[1]) }
  end

  def add_nodes
    create_nodes.each { |node| add_node(node) }
  end

  def add_node(node)
    nodes[node.name] = node
  end

  def adjacency_list(name)
    node_index = index(name)
    node_names.zip(score_matrix.row(node_index))
  end

  def connect_nodes
    node_names.each do |name|
      nodes[name].add_neighbours(adjacency_list(name))
    end
  end

  def index(name)
    node_names.index(name)
  end

  def reduced_adjacency_list(name)
    node_index = index(name)
    node_adj = adjacency_list(name)[node_index.next..-1]
    node_adj.select { |node_name, weight| [node_name, weight] if weight > 0 }
  end

  def self.from_json(data)
    obj = allocate
    obj.node_names = data["node_names"]
    obj.score_matrix = data["score_matrix"]
    obj.nodes = {}
    data["nodes"].each do |key, value|
      obj.nodes[key] = Node.from_json(value)
    end
    obj
  end
end
