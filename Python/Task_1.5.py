
import numpy as np
#Виводим масив abc_l із завдання task_1.4 щоб вивести коректно інформацію по розрахунку масивів
#Початок 0 кінец 1 n50 скільки рівномірних чисел створити
abc_l=np.linspace(0,1,50)
print("Масив рівномірно розподілених чисел:\n",abc_l)

#1.5 Знайди в масиві abc_l:

#мінімальне та максимальне значення; середнє значення; стандартне відхилення.

#Варіант 1
print("Min:",np.min(abc_l))
print("Max:",np.max(abc_l))
print("Mean:",np.mean(abc_l))
print("Std:",np.std(abc_l))

#Варіант 2
print("Статистика в один рядок:\n",np.min(abc_l),np.max(abc_l),np.mean(abc_l),np.std(abc_l))


#Варіант 3 через словник
starts={
    "Min":np.min(abc_l),
    "Max":np.max(abc_l),
    "Mean":np.mean(abc_l),
    "Std":np.std(abc_l)
}
print(starts)

#Варіант 4
print(f"Min:{np.min(abc_l)},Max:{np.max(abc_l)},Mean:{np.mean(abc_l):.2f},Std:{np.std(abc_l):.2f}")


