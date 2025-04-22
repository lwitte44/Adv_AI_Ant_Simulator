extends CharacterBody2D

# Get the animated sprite node of the ant agent so we can make it visually change directions
@onready var Animated_Sprite = $AnimatedSprite2D

# The Dictionary that holds the map of nodes
var Node_Map_Dictionary = {}

# Keeps track of the player's current node location.
var current_node = null  

# The target position the player is moving toward.
var target_position = Vector2()  

# Speed of movement (adjust as needed for a smoother transition).
var speed = 150.0  

# Define which direction to rotate towards using the radians
var direction_angles = {
	"NORTH": 0,            # Facing up
	"SOUTH": PI,           # Facing down
	"EAST": PI / 2,        # Facing right
	"WEST": -PI / 2        # Facing left
}

# Defines a boolean for fruit checking
var carrying_fruit = false

func _ready():
	
	add_to_group("ant")
	print("Is object in 'ant' group?", is_in_group("ant"))
	
	Node_Map_Dictionary = {
	$"../../Node_Map/HOME_NODE": [
		{"node": $"../../Node_Map/Node10", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node14", "direction": "WEST"},
		{"node": $"../../Node_Map/Node15", "direction": "EAST"},
		{"node": $"../../Node_Map/Node20", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node": [
		{"node": $"../../Node_Map/Node2", "direction": "EAST"},
		{"node": $"../../Node_Map/Node12", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node2": [
		{"node": $"../../Node_Map/Node3", "direction": "EAST"},
		{"node": $"../../Node_Map/Node7", "direction": "SOUTH"},
		{"node": $"../../Node_Map/Node", "direction": "WEST"}
	],
	$"../../Node_Map/Node3": [
		{"node": $"../../Node_Map/Node2", "direction": "WEST"},
		{"node": $"../../Node_Map/Node8", "direction": "SOUTH"},
		{"node": $"../../Node_Map/Node4", "direction": "EAST"}
	],
	$"../../Node_Map/Node4": [
		{"node": $"../../Node_Map/Node3", "direction": "WEST"},
		{"node": $"../../Node_Map/Node9", "direction": "SOUTH"},
		{"node": $"../../Node_Map/Node5", "direction": "EAST"}
	],
	$"../../Node_Map/Node5": [
		{"node": $"../../Node_Map/Node4", "direction": "WEST"},
		{"node": $"../../Node_Map/Node17", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node6": [
		{"node": $"../../Node_Map/Node7", "direction": "EAST"},
		{"node": $"../../Node_Map/Node14", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node7": [
		{"node": $"../../Node_Map/Node6", "direction": "WEST"},
		{"node": $"../../Node_Map/Node10", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node8": [
		{"node": $"../../Node_Map/Node3", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node9", "direction": "EAST"}
	],
	$"../../Node_Map/Node9": [
		{"node": $"../../Node_Map/Node4", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node8", "direction": "WEST"},
		{"node": $"../../Node_Map/Node16", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node10": [
		{"node": $"../../Node_Map/Node7", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node11", "direction": "EAST"},
		{"node": $"../../Node_Map/HOME_NODE", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node11": [
		{"node": $"../../Node_Map/Node10", "direction": "WEST"},
		{"node": $"../../Node_Map/Node15", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node12": [
		{"node": $"../../Node_Map/Node", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node13", "direction": "EAST"},
		{"node": $"../../Node_Map/Node18", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node13": [
		{"node": $"../../Node_Map/Node12", "direction": "WEST"},
		{"node": $"../../Node_Map/Node14", "direction": "EAST"},
		{"node": $"../../Node_Map/Node19", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node14": [
		{"node": $"../../Node_Map/Node6", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node13", "direction": "WEST"},
		{"node": $"../../Node_Map/HOME_NODE", "direction": "EAST"}
	],
	$"../../Node_Map/Node15": [
		{"node": $"../../Node_Map/Node11", "direction": "NORTH"},
		{"node": $"../../Node_Map/HOME_NODE", "direction": "WEST"},
		{"node": $"../../Node_Map/Node16", "direction": "EAST"},
		{"node": $"../../Node_Map/Node26", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node16": [
		{"node": $"../../Node_Map/Node9", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node15", "direction": "WEST"},
		{"node": $"../../Node_Map/Node17", "direction": "EAST"},
		{"node": $"../../Node_Map/Node21", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node17": [
		{"node": $"../../Node_Map/Node5", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node16", "direction": "WEST"},
		{"node": $"../../Node_Map/Node22", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node18": [
		{"node": $"../../Node_Map/Node12", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node19", "direction": "EAST"},
		{"node": $"../../Node_Map/Node23", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node19": [
		{"node": $"../../Node_Map/Node13", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node18", "direction": "WEST"},
		{"node": $"../../Node_Map/Node20", "direction": "EAST"},
		{"node": $"../../Node_Map/Node24", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node20": [
		{"node": $"../../Node_Map/HOME_NODE", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node19", "direction": "WEST"},
		{"node": $"../../Node_Map/Node25", "direction": "SOUTH"}
	],
	$"../../Node_Map/Node21": [
		{"node": $"../../Node_Map/Node29", "direction": "EAST"},
		{"node": $"../../Node_Map/Node16", "direction": "NORTH"}
	],
	$"../../Node_Map/Node22": [
		{"node": $"../../Node_Map/Node17", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node28", "direction": "SOUTH"},
		{"node": $"../../Node_Map/Node29", "direction": "WEST"}
	],
	$"../../Node_Map/Node23": [
		{"node": $"../../Node_Map/Node18", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node24", "direction": "EAST"}
	],
	$"../../Node_Map/Node24": [
		{"node": $"../../Node_Map/Node19", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node23", "direction": "WEST"},
		{"node": $"../../Node_Map/Node25", "direction": "EAST"}
	],
	$"../../Node_Map/Node25": [
		{"node": $"../../Node_Map/Node20", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node24", "direction": "WEST"},
		{"node": $"../../Node_Map/Node26", "direction": "EAST"}
	],
	$"../../Node_Map/Node26": [
		{"node": $"../../Node_Map/Node15", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node25", "direction": "WEST"},
		{"node": $"../../Node_Map/Node27", "direction": "EAST"}
	],
	$"../../Node_Map/Node27": [
		{"node": $"../../Node_Map/Node29", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node28", "direction": "EAST"},
		{"node": $"../../Node_Map/Node26", "direction": "WEST"}
	],
	$"../../Node_Map/Node28": [
		{"node": $"../../Node_Map/Node22", "direction": "NORTH"},
		{"node": $"../../Node_Map/Node27", "direction": "WEST"}
	],
	$"../../Node_Map/Node29": [
		{"node": $"../../Node_Map/Node21", "direction": "WEST"},
		{"node": $"../../Node_Map/Node22", "direction": "EAST"},
		{"node": $"../../Node_Map/Node27", "direction": "SOUTH"}
	]
	}
	
	#for key in Node_Map_Dictionary.keys():
		#print("Checking node:", key, "Exists:", key.is_inside_tree())
		
	# Sets the starting position to Node1.
	current_node = $"../../Node_Map/HOME_NODE"  
	print ("Starting Node is " + str(current_node))
	if current_node == null:
		print("Error: current_node is null!")
		return
	target_position = current_node.global_position
	global_position = target_position
	
# Function to move the player to a random connected node
func move_to_random_node():
	if Node_Map_Dictionary.has(current_node):  # Check if the current node has connections
		var possible_connections = Node_Map_Dictionary[current_node]
		var selected_connection = possible_connections[randi() % possible_connections.size()]  # Randomly pick one
		
		var next_node = selected_connection["node"]
		var direction = selected_connection["direction"]
		
		current_node = next_node
		target_position = current_node.global_position

		# Apply rotation based on direction
		if direction in direction_angles:
			rotation = direction_angles[direction]
			
		print("Moving " + direction + " to node: " + str(current_node))

# Using `_physics_process(delta)` for CharacterBody2D movement
func _physics_process(delta):
	#print("Physics Process Started")
	var direction_vector = (target_position - global_position).normalized()
	if global_position.distance_to(target_position) > 5:
		velocity = direction_vector * speed
		#print("Target is " + str(target_position) + "Velocity is " + str(velocity))
	else:
		velocity = Vector2.ZERO  # Stop when reaching the target
		move_to_random_node()  # Move to the next node automatically
	move_and_slide()
	
func _on_Fruit_area_entered(area):
	if area.is_in_group("fruit"):  # Detect fruit collision
		print("Picked up fruit at:", area.global_position)
		carrying_fruit = true  # Mark that the ant is carrying fruit
		move_home()  # Trigger return path using ACO
		
func move_home():
	if current_node != $"../Node_Map/HOME_NODE":
		var possible_paths = Node_Map_Dictionary[current_node]

		# Sort paths by pheromone strength (higher = more likely)
		possible_paths.sort_custom(func(a, b): return a["pheromone"] > b["pheromone"])
		
		var next_choice = possible_paths[0]  # Select strongest pheromone path
		current_node = next_choice["node"]
		target_position = current_node.global_position

		# Strengthen pheromone trail towards home
		next_choice["pheromone"] += 0.5  # Boost pheromone concentration
		print("Following reinforced pheromone trail towards home:", current_node)

# This code allows the ants to only move based on the spacebar
#func _input(event):
	#if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		#move_to_random_node()
		#print("Moved to: " + str(current_node) + " at position: " + str(target_position))
