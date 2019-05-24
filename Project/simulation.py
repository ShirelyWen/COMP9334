import random
import math
import numpy as np
#import matplotlib.pyplot as pl
#import operator
#from operator import itemgetter

def processorSharing(arrival_time, service_time):
    master_clock = 0
    next_arr = arrival_time[0][1]
    next_dep = np.inf
    jobs = []
    for i in range(len(arrival_time)):
        jobs.append([i,arrival_time[i][0],arrival_time[i][1]])
    job_list = []
    response_time = 0
    mean_response_time = 0
    completed = 0
    response_list = []
    depature_list = []

    while jobs != [] or job_list != []:
        if jobs != []:
            arrival_now = round(jobs[0][2],6)
            index = jobs[0][0]

            if arrival_now < next_dep:
                last_event = master_clock
                master_clock = arrival_now
                event_type = "Arrival"

                # if mode == "random" and master_clock > end_time:
                #     break

                if len(jobs) != 1:
                    next_arr = jobs[1][2]

                else:
                    next_arr = np.inf

                if job_list != []:
                    interval = len(job_list)
                    time_lapsed = round((master_clock - last_event),6)
                    subtract = round((time_lapsed/interval),6)
                    for i in job_list:
                        i[2] = round((i[2] - subtract),6)
                    job_list.append([jobs[0][1],arrival_time[index][1],service_time[index][1]])
                    job_list = sorted(job_list, key=lambda l: l[2], reverse=False)
                    #sorted(job_list, key=itemgetter(1))

                else:
                    job_list.append([jobs[0][1],arrival_time[index][1],service_time[index][1]])
                    job_list = sorted(job_list, key=lambda l: l[2], reverse=False)
                    #sorted(job_list, key=itemgetter(1))

                next_dep = round((master_clock + job_list[0][2] * len(job_list)),6)
                jobs.pop(0)
            else:
                last_event = master_clock
                master_clock = next_dep
                # if mode == "random" and master_clock > end_time:
                #     break
                event_type = "Departure"
                next_arr = arrival_now
                temp = job_list[0][2]
                arrival_index = job_list[0][1]
                for i in job_list:
                    i[2] = round((i[2] - temp), 6)
                response_time = round((master_clock - arrival_index),6)
                response_list.append([job_list[0][0], response_time])
                depature_list.append([job_list[0][0],master_clock])
                job_list.pop(0)
                completed += 1
                if job_list != []:
                    next_dep = round((master_clock + job_list[0][2] * len(job_list)), 6)
                else:
                    next_dep = np.inf
        else:
            last_event = master_clock
            master_clock = next_dep
            # if mode == "random" and master_clock > end_time:
            #     break
            event_type = "Departure"
            next_arr = np.inf
            temp = job_list[0][2]
            arrival_index = job_list[0][1]
            for i in job_list:
                i[2] = round((i[2] - temp), 6)
            response_time = round((master_clock - arrival_index), 6)
            response_list.append([job_list[0][0], response_time])
            depature_list.append([job_list[0][0], master_clock])
            job_list.pop(0)
            completed += 1
            if job_list != []:
                next_dep = round((master_clock + job_list[0][2] * len(job_list)),6)
            else:
                next_dep = np.inf
    depature_list = sorted(depature_list, key=lambda l: l[0], reverse=False)
    response_list = sorted(response_list, key=lambda l: l[0], reverse=False)
    for i in depature_list:
        i[1] = round(i[1],6)
    for i in response_list:
        i[1] = round(i[1],6)
    inter_list = []
    inter_list.append(depature_list)
    inter_list.append(response_list)
    inter_list.append(completed)
    #mean_response_time = round(response_time/completed,4)
    return inter_list

def Simulation(arrival_time, service_time, fogTimeLimit, network_latency, fogTimeToCloudTime):
    response_time = 0.0
    completed = 0
    fog_job_list = []
    cloud_job_list = []
    arrival_cloud = []
    service_cloud = []
    arrival_fog = []
    service_fog = []
    for i in range(len(arrival_time)):
        arrival_fog.append([i,arrival_time[i]])
    for i in range(len(service_time)):
        if round(service_time[i],6) >= fogTimeLimit:
            service_fog.append([i,fogTimeLimit])
        else:
            time = round(service_time[i], 6)
            service_fog.append([i,time])
    service_temp = []
    for i in range(len(service_time)):
        if round(service_time[i],6) >= fogTimeLimit:
            time = round((fogTimeToCloudTime * (service_time[i] - fogTimeLimit)),6)
            service_temp.append([i,time])
        else:
            service_temp.append([i, 0.0])
    arrival_temp = []
    result_fog = processorSharing(arrival_fog,service_fog)
    departure_fog = result_fog[0]
    # the time departure from gog
    fog_write = []
    for i in range(len(departure_fog)):
        a1 = round(arrival_time[i],4)
        a2 = round(departure_fog[i][1],4)
        fog_write.append([a1,a2])
    # count = 0
    # print(len(network_latency))
    for i in range(len(network_latency)):
        temp = round((departure_fog[i][1] + network_latency[i]),6)
        # count += 1
        # print(count)
        arrival_temp.append([i,temp,service_temp[i][1]])

        # the time departure from network
    network_write = []
    for i in range(len(network_latency)):
        if network_latency[i] != 0:
            a1 = round(arrival_time[i], 4)
            a2 = round(arrival_temp[i][1], 4)
            network_write.append([a1,a2])

    arrival_temp = sorted(arrival_temp, key=lambda l: l[1], reverse=False)
    for i in range(len(arrival_temp)):
        arrival_cloud.append([arrival_temp[i][0],arrival_temp[i][1]])
        service_cloud.append([arrival_temp[i][0],arrival_temp[i][2]])
    result_cloud = processorSharing(arrival_cloud,service_cloud)

    # the time departure from cloud
    departure_cloud = result_cloud[0]
    cloud_write = []
    for i in range(len(network_latency)):
        if network_latency[i] != 0:
            a1 = round(arrival_time[i], 4)
            a2 = round(departure_cloud[i][1],4)
            cloud_write.append([a1,a2])
    response_list = []
    for i in range(len(arrival_time)):
        temp = round((result_fog[1][i][1] + network_latency[i] + result_cloud[1][i][1]),6)
        temp1 = round((result_fog[1][i][1] + network_latency[i] + result_cloud[1][i][1]), 4)
        response_list.append(temp1)
        response_time = round((response_time + temp),6)

    # if result_fog[2] >= result_cloud[2]:
    completed = result_fog[2]
    # completed = result_cloud[2]
    #print(result_fog)
    #print(result_cloud)
    #print(response_time)
    #print(completed)
    mean_response_time = round((response_time/completed),4)
    result = []
    result.append(mean_response_time)
    result.append(fog_write)
    result.append(network_write)
    result.append(cloud_write)
    return result


#print(Simulation(arrival_list,service_list,fogTimeLimit,network_list,fogTimeToCloudTime))
