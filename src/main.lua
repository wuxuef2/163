--[[
��������⡿
��Ϸ����ֵ��ϵ������һϵ�л�򵥻��ӵĹ�ʽ���ɣ�СС��������ܾͻ����������Ӫ�¹ʡ�
���Բ�����ֵ���Ǳ���ʱ��С�ģ�һ����˵���ǳ��˷����ж���ֵ�����ԣ���Щʱ��ҪŪ��С
�ű�������������ЩУ�顣

������A��Ϸ���棬ĳ�����ܵ��˺�ֵd��ĳ����������x�����µ���ֵ��ϵ��
a*x^3 + b*x^2 + c*x + d = 0
���е�a��b��c�������ɲ߻�������Ҫ�趨��

ĳ������ĳλ����������ֶ���ĳ��ʱ��ε��˺�ֵ������˵����⣬��Ҫ������æɸѡ������
��ļ�������Ŀǰ���Ѿ��õ���һ���������ս����¼��log�ļ�����log����Ҳ�������
a��b��c��d�ĸ���������������Ҫ��д��ű����뷴�����Ӧ����������ֵx�����������һ��
У���ɸѡ�����������Ŀ��
======================================================================================
��Ҫ��
��ʵ���������p1_Equation
��������
4��number�Ͳ�����a, b, c, d�����ֱ����������������ֵ�����磨1, -6, 11, -6���ʹ�����ֵ
����x^3-6*x^2+11*x-6=0��
�����ء�
����һ���鲢������Ľ�����ַ���������ʵ��������λС���󣬹鲢��ȵĽ�����Դ�С����
�ķ�ʽ�ð�Ƕ��Ÿ�����ͬʵ�����أ��޽������nil���������������all���������������Ĳ���
���ӣ�1, -6, 11, -6����Ӧ������ַ�����1.00,2.00,3.00����

--]]
function sgn(x)
    if x > 0 then
        return 1
    elseif x < 0 then 
        return -1
    else    -- x = 0 时， 返回 0
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
�������󷨡�
Ϊ�˼Ӵ��ŶӸ�����Ȥζ����Ա����ȣ�B��Ϸ�Ĳ߻��Ƴ�һ���µĸ����淨�� �����ڸ����Ŷ�
����Ԥ����n�����ۣ�n����ҽ����󳡺��������ѡ��һ�����۽���վλ����ȫ�����۱����ռ
���󣬽�����һ���󷨣�Ϊ�ŶӴ���һЩս��Ч������ս���¼���

Ϊ�������󷨵ķḻ�ԣ��߻�ͬѧ�趨��һ�����򣺲�ͬ���ɵĽ�ɫվ��ͬһ�����ۻ���󷨴�
����ͬ��Ч��������ͬ���ɵĽ�ɫվ��ͬһ��������Ч����ͬ���κ�һ�������ϵĽ�ɫ�����ɸ�
�䶼����󷨴����ı䣻Ʃ�磬�±���ʾ��
����1     ����2     ����3
��һ��վλ   A������1��  B������2��  C������1��
�ڶ���վλ   B������2��  A������1��  C������1��
������վλ   C������1��  B������2��  A������1��
A��B��C������ɫ�����ɷֱ��ǣ�����1������2������1����һ��վλ��ʽ��Ϊ�͵�����վλ��ʽ
�����۵�����������һ�£����Բ�������Ч��һ�£����ڶ���վλ��ʽ��Ϊ�����۵���������
���б䶯������������˲�ͬ����Ч����

����Ϊ���������淨�Ŀ����ԣ���Ҫ���д�δ�������ڸ���������Ϣ����µĿ��ܴ�������
��������
======================================================================================
��Ҫ��
��ʵ�ֺ���p2_Dungeon
��������
1��table�Ͳ���{a1, a2,��, an}��ʾn����Ա���Ŷ�վλ��Ϣ��0<n<=200����table�е�n��Ԫ��an
������n�������ϵĽ�ɫ�����ɱ�ŵ���an�����磺{1,2,1}����ʾ3���������ηֱ�����1����
��2������1����վλ��
�����ء�
��������Ķ�����Ϣ�������ܵ��������������������������{1,2,1}��ͨ����ͬ���ɵĽ�ɫ��
��λ�ã�һ���ܲ���{2,1,1},{ 1,2,1},{1,1,2}�����󷨣����Խ��Ҫ���3��

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
С���Ǹ���ѧϰ���½����Թ���ʨ�����ڱ����ɵ���һ�������鸺��ĳ����Cocos2dX��������Ϸ
��Ʒ�Ĳ��ԣ�����֪Ҫ�Բ��ԵĶ����и���������벻����һЩ��ؿ���֪ʶ����Ϥ���������Լ�������
��һ������ƴͼ��С��Ϸ������һ�ѣ�
С��Ϸ���淨�ܾ��䣬m*n�ĸ��Ӿ����У��������1 ~ m*n-1��С���飬�����Ҫ����ʣ���һ
���ո������ƶ���ЩС���飬�������ջָ���������˳��
С��Ϊ��ʡ�£�һ��ʼ��ͨ�������ʽ����ʼ�����ƴͼ���У���������������ѶȻ���С����
�����ҵ��㣬�������æ����ԭ��д�õĴ���ӿ������һ���Զ���ԭƴͼ��AI�߼�������
======================================================================================
��Ҫ�󡿣��������д������ṩ�Ľӿڣ����p4_SlidePuzzle�������߼���ʵ���Զ��ָ�����ƴ
ͼ��AI�߼���
����������һ��������ʼ״̬���е�table���總���ĵ��е�ͼ���Ա�ʾΪ
{4,10,13,6,7,14,15,12,8,5,3,1,9,0,2,11}
�����ء������践�أ�ֻ��Ҫ��ִ֤��������AI�������ܳɹ��ָ����ɣ�
��API������
ͨ�������ʼ��ƴͼ�������е���newPuzzle�������Ի�ȡ���ص�һ���հ�table���ں������ǵĿ���API
���ǿ���ʹ���ṩ�Ĺ���api�ӿ���ɻָ�ƴͼ���߼������ýӿ��޶�Ϊ��
1��getNumbers( ):
���ã���ȡƴͼ�ĵ�ǰ����table
��������
���أ��Ե�ǰƴͼ�İ��˳�����е�����
2��moveNumber(position,direction)��
���ã������ƶ�ָ��λ�ã�position���ķǿ�ƴͼ����ָ������direction���ƶ�
*����޷��ƶ����ƶ���λ�ñ���Ϊ�գ�����������*
������
��position�� ,��3*3��ƴͼ��ȡֵΪ[1,9],����Ҫ�ƶ���λ��
�磺   1 2 3
4 5 6
7 8 9
��direction��, ȡֵΪ[1,4],����Ҫ�ƶ��ķ���
�磺   1������
2������
3������
4������

���أ���

3��getM():
���ã���ȡƴͼ��ˮƽ���������
��������
���أ�ƴͼ��ˮƽ���������

4��getN():
���ã���ȡƴͼ����ֱ���������
��������
���أ�ƴͼ����ֱ���������


--]]


--[[
newPuzzle������Ϊ�ṩ��ͬѧ�Ƿ�����Ե������ӿڣ����̨����ӿ����ƣ�����ʱ�����޸ģ����ⲻ��Ҫ����
��������
m:number�Ͳ�������ʾˮƽ����ĸ������� (m*n<=16)
n:number�Ͳ�������ʾ��ֱ����ĸ������� (m*n<=16)
initialPuzzle:table�Ͳ�����{a1, a2, a3, ...�� amxn}��ʾmxn�Ļ���ƴͼԪ�أ�
�������ң����ϵ��µ�˳����֯ƴͼԪ�أ�����{1,2,3,4,5,0,7,8,6}���൱��3x3��ƴͼ
1   2   3
4   5   0
7   8   6
�����ء�
�޷���Ҫ��
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
            
            distance = distance + math.abs(x1 - x2) + math.abs(x2 - y2)
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
            
            local value = curPuzzle[position]
            local trueX = math.floor((value - 1) % m)
            local trueY = math.floor((value - 1) / m)
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

function move(p, lastStep, maxStep, isSuc)
    local puzzle = p.getNumbers()
    local zero = getZero(puzzle)
    local m = p.getM()
    local n = p.getN()
        
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
                     
        if direction[i][2] ~= lastStep then
            local myPuzzle = puzzle;
            myPuzzle[direction[i][1]], myPuzzle[zero] = myPuzzle[zero], myPuzzle[direction[i][1]]
            local key = puzzleHash(myPuzzle)            
            
            if distanceCal(myPuzzle, m, n) <= maxStep then
                        
                p.moveNumber(direction[i][1], direction[i][2])
                local tmp
                if isSuccess(p.getNumbers()) then
                    isSuc = true
                    return
                else
                    local int, fra = math.modf(direction[i][2] / 2)
                    tmp = 4 - direction[i][2]
                    if fra == 0 then
                        tmp = 6 - direction[i][2]
                    end
                    --printTable(p.getNumbers()) 
                    --print(maxStep)
                    move(p, tmp, maxStep, isSuc)
                end
                
                p.moveNumber(zero, tmp)
                
            end
        end  
    end  
end

--�Զ���ԭ��ִ���߼��ڽ�ͨ�����ô˺���ʵ�֣����践�أ�
function p4_SlidePuzzle(p)
    local position = getZero(p.getNumbers())    
    if isSuccess(p.getNumbers()) then
        return
    end
    
    local puzzle = p.getNumbers()
    local maxStep = distanceCal(puzzle, p.getM(), p.getN()) * 4
    times = 1
    while not isSuccess(p.getNumbers()) do
        move(p, 0, maxStep, false)
        maxStep = maxStep + 1
        times = times + 1
        
    end
    print(times)
end

--����ִ�����ӣ����̨�����߼����ƣ���ȷ������ͨ�˻����������ύ����
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

--print (testSample(3,3,{1,2,3,4,5,6,7,0,8})) --�ύǰע��ע�͵����е��������


local function main()
print (testSample(3,3,{1,2,3,4,5,6,7,0,8}))
local t = os.time()
print (testSample(4,4,{5,7,2,3,1,10,6,4,14,13,11,8,0,9,15,12}))
print(os.time() - t)
end
main()