from datetime import datetime, timedelta

def print_time_schedule(start_time_str, cycles=6):
    # 初始化开始时间
    start_time = datetime.strptime(start_time_str, "%H:%M:%S")
    current_time = start_time

    for cycle in range(1, cycles + 1):
        print(f"\nCycle {cycle}:")

        # Step 1: 观测目标源 5分钟，并注入噪音
        print(f"{current_time.strftime('%H:%M:%S')} - Start observing target & Noise ON (5 min)")
        print(f"{(current_time + timedelta(seconds=20)).strftime('%H:%M:%S')} - Noise OFF (on target)")
        current_time += timedelta(minutes=5)

        # Step 2: 移动到参考源位置 1分钟，并注入噪音
        print(f"{current_time.strftime('%H:%M:%S')} - Start shift to reference & Noise ON (1 min)")
        print(f"{(current_time + timedelta(seconds=20)).strftime('%H:%M:%S')} - Noise OFF (during shift)")
        current_time += timedelta(minutes=1)

        # Step 3: 观测参考源 5分钟，并注入噪音
        print(f"{current_time.strftime('%H:%M:%S')} - Start observing reference & Noise ON (5 min)")
        print(f"{(current_time + timedelta(seconds=20)).strftime('%H:%M:%S')} - Noise OFF (on reference)")
        current_time += timedelta(minutes=5)

        # Step 4: 最后的 shift back 特殊处理
        print(f"{current_time.strftime('%H:%M:%S')} - Start shift back to target (1 min)")
        if cycle < cycles:  # 只有不是最后一个循环时才注入噪音
            print(f"{current_time.strftime('%H:%M:%S')} - Noise ON (during shift)")
            print(f"{(current_time + timedelta(seconds=20)).strftime('%H:%M:%S')} - Noise OFF (during shift)")
        current_time += timedelta(minutes=1)

# 示例：从00:00:00开始观测
print_time_schedule("20:14:00")