--[[
【方程求解】
游戏的数值体系往往由一系列或简单或复杂的公式构成，小小的问题可能就会引发大的运营事故。
所以测试数值我们必须时刻小心！一般来说我们除了分析判断数值合理性，有些时候还要弄点小
脚本帮助我们来做些校验。

假设在A游戏里面，某个技能的伤害值d和某个人物属性x有以下的数值关系：
a*x^3 + b*x^2 + c*x + d = 0
其中的a、b、c参数则由策划根据需要设定；

某天由于某位程序锅锅的手抖，某个时间段的伤害值计算出了点问题，需要你来帮忙筛选出有问
题的计算结果；目前你已经拿到了一个有问题的战斗记录的log文件，从log中你也分离出了
a、b、c、d四个参数，现在你需要简单写点脚本代码反算出对应的人物属性值x，方便后续进一步
校验和筛选出有问题的条目。
======================================================================================
【要求】
请实现求根函数p1_Equation
【参数】
4个number型参数（a, b, c, d），分别代表题中所述的数值，比如（1, -6, 11, -6）就代表数值
满足x^3-6*x^2+11*x-6=0。
【返回】
返回一个归并且排序的结果集字符串，所有实根保留两位小数后，归并相等的结果并以从小到大
的方式用半角逗号隔开不同实根返回（无解输出“nil”，无数解输出“all”），比如上述的参数
例子（1, -6, 11, -6），应该输出字符串”1.00,2.00,3.00”。

--]]
function sgn(x)
    if x > 0 then
        return 1
    elseif x < 0 then 
        return -1
    else    -- x = 0 鏃讹紝 杩斿洖 0
        return 0
    end
end

function pows(x, y)
    return sgn(x)* (math.abs(x) ^ y)
end

ZERO = 1e-12
function isZero(value)
    ZERO = 1e-12
    return -1.0 * ZERO < value and value < 1.0 * ZERO
end

-- a ~= 0
function cubic_Equations(a,b,c,d)
    a = 1
    b = b / a
    c = c / a
    d = d / a
    
    
    local A = b * b - 3 * a * c
    local B = b * c - 9 * a * d
    local C = c * c - 3 * b * d

    local disc = B * B - 4 * A * C

    local Y1 = A * b + 3 * a * (-B + math.sqrt(B * B - 4 * A * C)) / 2;
    local Y2 = A * b + 3 * a * (-B - math.sqrt(B * B - 4 * A * C)) / 2;

    local ans = {}
    if isZero(A) and isZero(B) then
        table.insert(ans, -c / b)
    elseif disc > ZERO then
        table.insert(ans, (-b - pows(Y1, 1.0 / 3) - pows(Y2, 1.0 / 3)) / (3 * a))
    elseif isZero(disc) then
        local K = B / A
        table.insert(ans, -b / a + K)
        table.insert(ans, -K / 2)
    elseif disc < -ZERO then
        local T = (2 * A * b - 3  * a * B) / (2 * pows(A, 3.0 / 2))
        local air = math.acos(T)
        table.insert(ans, (-b - 2 * math.sqrt(A) * math.cos(air / 3)) / (3 * a))
        table.insert(ans, (-b + math.sqrt(A) * (math.cos(air / 3) + math.sqrt(3.0) * math.sin(air / 3))) / (3 * a))
        table.insert(ans, (-b + math.sqrt(A) * (math.cos(air / 3) - math.sqrt(3.0) * math.sin(air / 3))) / (3 * a))
    end  

    return ans 
end

function quadratic_Equations(a, b, c)
    local ans = {}
    local delta = b * b - 4 * a * c

    if isZero(a) then
        if not isZero(b) then
            table.insert(ans, -c / b)
        else
            if isZero(c) then
                table.insert(ans, 'all')
            end
        end
    elseif isZero(delta) then
        table.insert(ans, -b / (2 * a))
    elseif delta > 0 then
        table.insert(ans, (-b + math.sqrt(delta)) / (2 * a))
        table.insert(ans, (-b - math.sqrt(delta)) / (2 * a))
    end

    return ans
end

function p1_Equation(a,b,c,d)
    local ans
    if a ~= 0 then
        ans = cubic_Equations(a, b, c, d)
    else 
        ans = quadratic_Equations(b, c, d)
    end

    local solution = {}
    if next(ans) == nil then
        return 'nil'
    elseif ans[1] == 'all' then
        return 'all'
    else 
        table.sort(ans, function(a, b)
            return a < b
        end)
        for key, value in pairs(ans) do
            table.insert(solution, string.format("%.2f", value))
        end
                
        return table.concat(solution, ",")
    end
    
    
end

--[[
【副本阵法】
为了加大团队副本的趣味与人员参与度，B游戏的策划推出一个新的副本玩法： 副本内根据团队
人数预设了n个阵眼，n个玩家进入阵场后可以自由选择一个阵眼进行站位，当全部阵眼被玩家占
满后，将触发一个阵法，为团队带来一些战斗效果或者战斗事件。

为了增加阵法的丰富性，策划同学设定了一个规则：不同门派的角色站在同一个阵眼会对阵法带
来不同的效果，但相同门派的角色站在同一个阵眼则效果相同，任何一个阵眼上的角色的门派改
变都会对阵法带来改变；譬如，下表所示，
阵眼1     阵眼2     阵眼3
第一种站位   A（门派1）  B（门派2）  C（门派1）
第二种站位   B（门派2）  A（门派1）  C（门派1）
第三种站位   C（门派1）  B（门派2）  A（门派1）
A、B、C三个角色的门派分别是：门派1、门派2、门派1；第一种站位方式因为和第三种站位方式
在阵眼的门派序列上一致，所以产生的阵法效果一致；而第二种站位方式因为在阵眼的门派序列
上有变动，所以则产生了不同的阵法效果；

现在为了评估该玩法的可行性，需要你简单写段代码计算在给定队伍信息情况下的可能触发的阵
法数量。
======================================================================================
【要求】
请实现函数p2_Dungeon
【参数】
1个table型参数{a1, a2,…, an}表示n个队员的团队站位信息（0<n<=200），table中第n个元素an
代表第n个阵眼上的角色，门派编号等于an，比如：{1,2,1}，表示3个阵眼依次分别被门派1、门
派2和门派1的人站位。
【返回】
根据输入的队伍信息给出可能的阵法总数，比如上述的输入参数{1,2,1}，通过不同门派的角色互
换位置，一共能产生{2,1,1},{ 1,2,1},{1,1,2}三种阵法，所以结果要输出3。

--]]

function p2_Dungeon(t)
    table.sort(t, function(a, b)
        return (a < b)
    end
    )

    local size = #t
    local factions = {}
    table.insert(factions, 1, 1)
    local curValue = t[1]
    local index = 1

    for i = 2, size do
        if t[i] == curValue then
            factions[index] = factions[index] + 1
        else
            index = index + 1
            table.insert(factions, index, 1)
            curValue = t[i]
        end
    end
    
    table.sort(factions,function(a, b)
        return (b < a)
    end
    )
    
    local counter = 1
    local hold = 1
    local sizeOfFactions = index
    index = 1
    for i = size, 2, -1 do
        counter = counter * i
        
        while index <= sizeOfFactions or hold ~= 1 do
          if hold == 1 and index <= sizeOfFactions then            
              hold = factions[index]
              index = index + 1
          end
  
          if hold ~= 1 then        
              int, fra = math.modf(counter / hold)
              if fra == 0 and int > 0 then
                  counter = counter / hold                
                  hold = hold - 1
              else 
                  break
              end    
          end
       end
    end
    

    return counter;
end







--[[
小明是个爱学习的新晋测试攻城狮，近期被分派到了一个手游组负责某款用Cocos2dX开发的游戏
产品的测试；他深知要对测试的对象有更深的理解离不开对一些相关开发知识的熟悉，于是他自己试着做
了一个滑块拼图的小游戏练手了一把；
小游戏的玩法很经典，m*n的格子矩阵中，乱序放了1 ~ m*n-1个小滑块，玩家需要利用剩余的一
个空格子来移动这些小滑块，以求最终恢复到正常的顺序；
小明为了省事，一开始是通过随机方式来初始化这个拼图序列，结果玩起来发现难度还不小！于
是他找到你，想让你帮忙在他原来写好的代码接口上完成一个自动复原拼图的AI逻辑函数。
======================================================================================
【要求】：利用已有代码中提供的接口，填充p4_SlidePuzzle函数的逻辑，实现自动恢复滑块拼
图的AI逻辑。
【参数】：一个代表初始状态序列的table，如附件文档中的图可以表示为
{4,10,13,6,7,14,15,12,8,5,3,1,9,0,2,11}
【返回】：无需返回，只需要保证执行所填充的AI函数后能成功恢复即可；
【API概述】
通过传入初始的拼图乱序序列调用newPuzzle方法可以获取返回的一个闭包table，内含了我们的可用API
我们可以使用提供的公用api接口完成恢复拼图的逻辑，可用接口限定为：
1、getNumbers( ):
作用：获取拼图的当前序列table
参数：无
返回：以当前拼图的板块顺序排列的数组
2、moveNumber(position,direction)：
作用：尝试移动指定位置（position）的非空拼图块向指定方向（direction）移动
*如果无法移动或移动的位置本身为空，将不作操作*
参数：
【position】 ,如3*3的拼图，取值为[1,9],代表要移动的位置
如：   1 2 3
4 5 6
7 8 9
【direction】, 取值为[1,4],代表要移动的方向
如：   1：向上
2：向右
3：向下
4：向左

返回：无

3、getM():
作用：获取拼图的水平方向格子数
参数：无
返回：拼图的水平方向格子数

4、getN():
作用：获取拼图的竖直方向格子数
参数：无
返回：拼图的竖直方向格子数


--]]


--[[
newPuzzle函数作为提供给同学们方便调试的样例接口，与后台判题接口类似，调试时请勿修改，避免不必要出错
【参数】
m:number型参数，表示水平方向的格子数量 (m*n<=16)
n:number型参数，表示竖直方向的格子数量 (m*n<=16)
initialPuzzle:table型参数，{a1, a2, a3, ...， amxn}表示mxn的滑板拼图元素，
按从左到右，从上到下的顺序组织拼图元素，比如{1,2,3,4,5,0,7,8,6}就相当于3x3的拼图
1   2   3
4   5   0
7   8   6
【返回】
无返回要求
--]]
function newPuzzle(m,n,initialPuzzle)
    if (m*n)~=#initialPuzzle then return end

    local self={puzzle=initialPuzzle,sizeM=m,sizeN=n}

    local getNumbers=function ()
        puzzleCopy={}
        for i,v in ipairs(self.puzzle) do
            puzzleCopy[i]=v
        end
        return puzzleCopy
    end

    local getM=function ()
        local localM=self.sizeM;
        return localM
    end

    local getN=function ()
        local localN=self.sizeN;
        return localN
    end

    local moveNumber=function (position,direction)
        if self.puzzle[position] and self.puzzle[position]>0 then
            local x=math.floor((position-1 )%m)
            local y=math.floor((position-1 )/m)

            local moveSteps={{0,-1},{1,0},{0,1},{-1,0}}
            local newX=x+moveSteps[direction][1]
            local newY=y+moveSteps[direction][2]

            if newX>= 0 and newX<m and newY>=0 and newY<n then
                local newPos=newY*m+newX+1
                if self.puzzle[newPos]==0 then
                    self.puzzle[newPos],self.puzzle[position] = self.puzzle[position],self.puzzle[newPos]
                end
            end
        end
    end

    return{
        getM=getM,
        getN=getN,
        getNumbers=getNumbers,
        moveNumber=moveNumber
    }
end


function isSuccess(t)
    local len = #(t) - 1
    
    for i = 1, len do
        if t[i] ~= i then
            return false
        end
    end
    
    return t[#(t)] == 0
end

function getZero(t)
    for key, value in ipairs(t) do
        if value == 0 then
            return key
        end
    end
    
    return 0 
end

function distanceCal(curPuzzle, m, n)
    local distance = 0 
    for i = 1, m * n do
        if curPuzzle[i] ~= 0 then
            local position = curPuzzle[i]
            local x1 = math.floor((position - 1) % m)
            local y1 = math.floor((position - 1) / m)
            
            local x2 = math.floor((i - 1) % m)
            local y2 = math.floor((i - 1) / m)
            
            distance = distance + math.abs(x1 - x2) + math.abs(y1 - y2)
        end        
    end

    return distance
end

flag = {}
function puzzleHash(puzzle) 
    local hash = puzzle[1]
    base = 16
    for i = 2, #puzzle do
        hash = hash + puzzle[i] * base
        base = base * 16
    end
    
    return hash
end



function getMoveDirection(curPuzzle, zero, m, n)
    local x = math.floor((zero - 1) % m)
    local y = math.floor((zero - 1) / m)
    local moveSteps = {{0,1}, {-1,0}, {0,-1}, {1,0}}

    local direction = {}
    for i = 1, 4 do
        local newX = x + moveSteps[i][1]
        local newY = y + moveSteps[i][2]
        if newX >= 0 and newX < m and newY >= 0 and newY < n then
            local position = newY * m + newX + 1            
            
            --local value = curPuzzle[position]
            --local trueX = math.floor((value - 1) % m)
            --local trueY = math.floor((value - 1) / m)
            --local cost = math.abs(trueX - newX) + math.abs(trueY - newY)
            
            table.insert(direction, {position, i})
        end
    end
    
    --[[
    for i = 2, #direction do
        local val = direction[i]
        local index = 0
        for j = i - 1, 1, -1 do
            index = j
            if direction[j][3] < val[3] then
                direction[j + 1] = direction[j]
            else  
                break
            end
        end
       
        if index ~= i - 1 then
            direction[index] = val    
        end
    end
    ]]
    
    return direction
end

function printTable(t)
    print(table.concat(t, ","))
end

function isClose(value, position, direction, m, n)
    local x = math.floor((position - 1) % m)
    local y = math.floor((position - 1) / m)
    
    local trueX = math.floor((value - 1) % m)
    local trueY = math.floor((value - 1) / m)
    
    if direction == 1 and trueY < y then
        return -1
    elseif direction == 2 and trueX > x then
        return -1
    elseif direction == 3 and trueY > y then
        return -1
    elseif direction == 4 and trueX < x then
        return -1
    else
        return 1
    end
end

isSuc = false
function move(PUZZLE, lastStep, maxStep, cost)
    local puzzle = PUZZLE.puzzle
    local zero = PUZZLE.curZero
    local m = PUZZLE.m
    local n = PUZZLE.n
        
    local direction = getMoveDirection(puzzle, zero, m, n)
    
    if isSuc or maxStep <= 0 then 
        return
    else
        maxStep = maxStep - 1
    end        
    
    for i = 1, #direction do
        if isSuc or maxStep <= 0 then
            return
        end
        
        local close = isClose(puzzle[direction[i][1]], direction[i][1], direction[i][2], m, n)           
        if direction[i][2] ~= lastStep and cost + close <= maxStep then
                      
              --move number and reset zero            
              puzzle[direction[i][1]], puzzle[zero] = puzzle[zero], puzzle[direction[i][1]]
              PUZZLE.curZero = direction[i][1]
              table.insert(PUZZLE.path, {direction[i][1], direction[i][2]})
              
              local tmp
              if isSuccess(PUZZLE.puzzle) then
                  isSuc = true
                  return
              else
                  local int, fra = math.modf(direction[i][2] / 2)
                  tmp = 4 - direction[i][2]
                  if fra == 0 then
                      tmp = 6 - direction[i][2]
                  end
                  
                  move(PUZZLE, tmp, maxStep, cost + close)
                  
                  if isSuc then return end
              end
              
                
              puzzle[direction[i][1]], puzzle[zero] = puzzle[zero], puzzle[direction[i][1]]
              PUZZLE.curZero = zero                        
              table.remove(PUZZLE.path, #(PUZZLE.path))
        end  
    end  
end



function moveNumber(PUZZLE, p)
    for i = 1, #(PUZZLE.path) do
        p.moveNumber(PUZZLE.path[i][1], PUZZLE.path[i][2])
    end
end

--自动复原的执行逻辑在将通过调用此函数实现，无需返回；
function p4_SlidePuzzle(p)   
    local puz = p.getNumbers()
    local zero = getZero(puz)
    
    local PUZZLE = {
        puzzle = puz,
        m = p.getM(),
        n = p.getN(),
        initZero = zero,
        curZero = zero,
        path = {}
    }
        
    if isSuccess(PUZZLE.puzzle) then
        return
    end
    
    local monD = distanceCal(PUZZLE.puzzle, PUZZLE.m, PUZZLE.n)
    local maxStep = monD
    isSuc = false
    while not isSuc do
        move(PUZZLE, 0, maxStep, monD)
        maxStep = maxStep + 1     
    end
    
    moveNumber(PUZZLE, p)
end

--样例执行例子，与后台判题逻辑类似，请确保能跑通此基本用例才提交代码
function testSample(m,n,t)
    p1=newPuzzle(m,n,t)
    p4_SlidePuzzle(p1)
    local resStr="";
    local finalT=p1.getNumbers()
    for i,v in ipairs(finalT) do
        resStr=resStr .. v
    end
    return resStr

end

--print (testSample(3,3,{1,2,3,4,5,6,7,0,8})) --提交前注意注释掉所有的输出操作


local function main()
print (testSample(3,3,{1,2,3,4,0,6,7,5,8}))
print (testSample(3,3,{3,2,1,7,4,5,6,0,8}))
local t = os.time()
print (testSample(4,4,{5,7,2,3,1,10,6,4,14,13,11,8,0,9,15,12}))
print (testSample(4,4,{1,2,7,3,5,6,4,12,9,14,11,15,13,8,0,10}))
--print (testSample(4,4,{1,5,10,2,11,7,6,0,14,15,3,8,13,9,4,12}))
print(os.time() - t)
end
main()
