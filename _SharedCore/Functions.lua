--/////////////////////////////////////--
-- Functions LUA

-- Author: SilverEzredes
-- Updated: 12/20/2023
-- Version: v1.0.5
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--

local function check_GameName(GameName)
    if reframework.get_game_name() ~= GameName then
       return
    end
end

local function get_CurrentScene()
    local scene_manager = sdk.get_native_singleton("via.SceneManager")

    if scene_manager then
        scene = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
    end

    return scene
end

local function get_GameObject(scene, GameObjectName)
    return scene:call("findGameObject(System.String)", GameObjectName)
end

local function get_GameObjects(scene, GameObjectNames)
    local found_GameObjects = {}

    for i, name in ipairs(GameObjectNames) do
        local gameObject = scene:call("findGameObject(System.String)", name)

        if gameObject then
            table.insert(found_GameObjects, gameObject)
        end
    end

    return found_GameObjects
end

local function get_GameObjectComponent(GameObject, ComponentType)
	return GameObject and GameObject:call("getComponent(System.Type)", sdk.typeof(ComponentType))
end

local function get_Field(GameObject, FieldName)
    return GameObject:get_field(FieldName)
end

local function call_Method(GameObject, MethodName, NewValue)
    return GameObject:call(MethodName, NewValue)
end

local function boolean_ToInt(BoolName)
    if BoolName then
        return 1
      else
        return 0
    end
end

local function boolean_ToFloat(BoolName)
    if BoolName then
        return 1.0
      else
        return 0.0
    end
end

local function int_ToBoolean(IntName)
    if IntName == 1 then
        return true
      else
        return false
    end
end

local function float_ToBoolean(FloatName)
    if FloatName == 1.0 then
        return true
      else
        return false
    end
end

local function convert_rgb_to_vector3f(red, green, blue)
    local vector = Vector3f.new(red / 255, green / 255, blue / 255)
    return vector
end

local function convert_vector3f_to_rgb(vector)
    local R = math.floor(vector.x * 255)
    local G = math.floor(vector.y * 255)
    local B = math.floor(vector.z * 255)
    return R, G, B
end

local function convert_rgba_to_vector4f(red, green, blue, alpha)
    local vector = Vector4f.new(red / 255, green / 255, blue / 255, alpha / 255)
    return vector
end

local function convert_vector4f_to_rgba(vector)
    local R = math.floor(vector.x * 255)
    local G = math.floor(vector.y * 255)
    local B = math.floor(vector.z * 255)
    local A = math.floor(vector.w * 255)
    return R, G, B, A
end

local function table_contains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function recurse_def_settings(tbl, defaults_tbl)
	for key, value in pairs(defaults_tbl) do
		if type(tbl[key]) ~= type(value) then
			if type(value) == "table" then
				tbl[key] = recurse_def_settings({}, value)
			else
				tbl[key] = value
			end
		elseif type(value) == "table" then
			tbl[key] = recurse_def_settings(tbl[key], value)
		end
	end
	return tbl
end

local function tooltip(text, do_force)
    if do_force or imgui.is_item_hovered() then
        imgui.set_tooltip(text)
    end
end

local function colored_TextSwitch(SampleText, StateSwitchName, State_01, Color_01, State_02, Color_02)
    imgui.button(SampleText)
    imgui.same_line()
    if StateSwitchName then
        imgui.text_colored(State_01, Color_01)
    else
        imgui.text_colored(State_02, Color_02)
    end
end


local function create_resource(resource_path, resource_type)
    local new_resource = sdk.create_resource(resource_type, resource_path)
    if new_resource then 
        new_resource:add_ref()
        local holder = sdk.create_instance(resource_type .. "Holder")
        if sdk.is_managed_object(holder) then 
            holder:call(".ctor")
            holder:write_qword(0x10, new_resource:get_address())
            holder:add_ref()
            return holder
        end
    end
end

func = {
    check_GameName = check_GameName,
    get_CurrentScene = get_CurrentScene,
    get_GameObject = get_GameObject,
    get_GameObjects = get_GameObjects,
    get_GameObjectComponent = get_GameObjectComponent,
    get_Field = get_Field,
    call_Method = call_Method,
    boolean_ToInt = boolean_ToInt,
    boolean_ToFloat = boolean_ToFloat,
    int_ToBoolean = int_ToBoolean,
    float_ToBoolean = float_ToBoolean,
    convert_rgb_to_vector3f = convert_rgb_to_vector3f,
    convert_vector3f_to_rgb = convert_vector3f_to_rgb,
    convert_rgba_to_vector4f = convert_rgba_to_vector4f,
    convert_vector4f_to_rgba = convert_vector4f_to_rgba,
    recurse_def_settings = recurse_def_settings,
    tooltip = tooltip,
    colored_TextSwitch = colored_TextSwitch,
    create_resource = create_resource,
    table_contains = table_contains,
}

return func