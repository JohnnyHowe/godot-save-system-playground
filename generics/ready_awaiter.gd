class_name ReadyAwaiter


static func wait_until_ready(node: Node) -> void:
	if node.is_node_ready():
		return
	await node.ready

	var tree = node.get_tree()
	if not tree:
		return
	await tree.process_frame