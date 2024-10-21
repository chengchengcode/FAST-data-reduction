from datetime import datetime, timedelta

def generate_time_table(start_time_str, cycles=7):
    # 初始化开始时间
    start_time = datetime.strptime(start_time_str, "%H:%M:%S")
    current_time = start_time

    # 打印表头
    print(f"{'Cycle':<6} {'Event':<40} {'Time'}")
    print("-" * 60)

    # 生成时间表
    for cycle in range(1, cycles + 1):
        # 判断是否是第一个Cycle
        if cycle == 1:
            print(f"{cycle:<6} Start observing target                {current_time.strftime('%H:%M:%S')}")
        else:
            print(f"{cycle:<6} Shift back & Start observing target   {current_time.strftime('%H:%M:%S')}")

        current_time += timedelta(minutes=5)

        print(f"{cycle:<6} Start shift to reference              {current_time.strftime('%H:%M:%S')}")
        current_time += timedelta(minutes=1)

        print(f"{cycle:<6} Start observing reference             {current_time.strftime('%H:%M:%S')}")
        current_time += timedelta(minutes=5)

        # 如果是最后一个Cycle，不再加1分钟的shift时间
        if cycle < cycles:
            print(f"{cycle:<6} Start shift back to target            {current_time.strftime('%H:%M:%S')}")
            current_time += timedelta(minutes=1)
            print(f"{cycle:<6} Cycle finished                        {current_time.strftime('%H:%M:%S')}\n")
        else:
            print(f"{cycle:<6} Cycle finished                        {current_time.strftime('%H:%M:%S')}\n")

# 示例：从00:00:00开始观测
generate_time_table("00:00:00")
