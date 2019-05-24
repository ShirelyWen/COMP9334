from simulation import Simulation
import numpy as np
import random
import math

#import matplotlib.pyplot as plt
import statistics


random.seed(1)
# generate arrival time according to exponential distribution
def getArrivalTime(lam,time_end):
    arrival_list = []
    arrival_time = 0
    while arrival_time < time_end:
        inter_arrival_time = random.expovariate(lam)
        inter_arrival_time = round(inter_arrival_time,6)
        arrival_time = round((arrival_time + inter_arrival_time),6)
        arrival_list.append(arrival_time)
    for i in range(len(arrival_list)):
        if arrival_list[i] > time_end:
            arrival_list.pop(i)
    arrival_list.sort()
    return arrival_list


# generate service time according to function given by documentation
def getServiceTime(alpha1,alpha2,beta,requests_number):
    # calculate gama
    gama = (1.0 - beta) / ((alpha2 ** (1.0 - beta)) - (alpha1 ** (1.0 - beta)))
    service_list_random = []
    for i in range(0, requests_number):
        prob = random.random()
        prob = round(prob, 6)
        time = (prob * (1.0 - beta) / gama + alpha1 ** (1.0 - beta)) ** (1.0 / (1.0 - beta))
        service_list_random.append(round(time,6))
    #print(len(service_list_random))
    return service_list_random


# generate network latency according to uniform distribution
def getNetworkLatency(v1,v2,requests_number):
    network_latency = []
    for i in range(0, requests_number):
        network = random.uniform(v1,v2)
        network = round(network,6)
        network_latency.append(network)
    #print(len(network_latency))
    return network_latency


number = open('project_sample_files/num_tests.txt','r').read()
#print(number)
#number = 4
for text_index in range(1,int(number)+1):
    mode=open('project_sample_files/mode_{}.txt'.format(text_index),'r').read()
    if mode=='trace':
        arrival_time = open('project_sample_files/arrival_{}.txt'.format(text_index), 'r').read()
        service_time = open('project_sample_files/service_{}.txt'.format(text_index), 'r').read()
        network_latency = open('project_sample_files/network_{}.txt'.format(text_index), 'r').read()
        para = open('project_sample_files/para_{}.txt'.format(text_index), 'r').read()
        arrival=np.matrix(arrival_time).tolist()
        arrival=arrival[0]
        service = np.matrix(service_time).tolist()
        service=service[0]
        network = np.matrix(network_latency).tolist()
        network = network[0]
        para_list = np.matrix(para).tolist()
        para_list = para_list[0]
        fogTimeLimit = para_list[0]
        fogTimeToCloudTime = para_list[1]
        result=Simulation(arrival, service, fogTimeLimit, network, fogTimeToCloudTime)
        #print(result)

        with open('mrt_{}.txt'.format(text_index),'w') as f:
            f.write("%.4f" % result[0])

        with open('fog_dep_{}.txt'.format(text_index),'w') as f:
            for i in range(len(result[1])):
                f.write(format(result[1][i][0], '0.4f'))
                f.write('\t')
                f.write(format(result[1][i][1], '0.4f'))
                f.write('\n')

        with open('net_dep_{}.txt'.format(text_index), 'w') as f:
            for i in range(len(result[2])):
                f.write(format(result[2][i][0], '0.4f'))
                f.write('\t')
                f.write(format(result[2][i][1], '0.4f'))
                f.write('\n')

        with open('cloud_dep_{}.txt'.format(text_index), 'w') as f:
            for i in range(len(result[3])):
                f.write(format(result[3][i][0], '0.4f'))
                f.write('\t')
                f.write(format(result[3][i][1], '0.4f'))
                f.write('\n')

    if mode =='random':
        # get the parameters
        lam = open('project_sample_files/arrival_{}.txt'.format(text_index),'r').read()
        service_para = open('project_sample_files/service_{}.txt'.format(text_index),'r').read()
        network_list = open('project_sample_files/network_{}.txt'.format(text_index), 'r').read()
        para = open('project_sample_files/para_{}.txt'.format(text_index), 'r').read()
        lam = np.matrix(lam).tolist()
        lam = lam[0][0]
        #print(lam)
        service_para = np.matrix(service_para).tolist()
        service_para = service_para[0]
        alpha1 = service_para[0]
        alpha2 = service_para[1]
        beta = service_para[2]
        #print(alpha1,alpha2,beta)
        network_para = np.matrix(network_list).tolist()
        network_para = network_para[0]
        v1 = network_para[0]
        v2 = network_para[1]
        #print(v1,v2)
        para_list = np.matrix(para).tolist()
        para_list = para_list[0]
        fogTimeLimit = para_list[0]
        fogTimeToCloudTime = para_list[1]
        time_end = para_list[2]

        # plot the mrt 100 times for reproducible
        # mrt = []
        # for i in range(0,100):
        #     random.seed(1)
        #     arrival = getArrivalTime(lam, time_end)
        #     # arrival_list.sort()
        #     requests_number = len(arrival)
        #     service = getServiceTime(alpha1, alpha2, beta, requests_number)
        #     network = getNetworkLatency(v1, v2, requests_number)
        #     for i in range(len(service)):
        #         if service[i] <= fogTimeLimit:
        #             network[i] = 0.0
        #     result = Simulation(arrival, service, fogTimeLimit, network, fogTimeToCloudTime)
        #     temp = round(result[0],4)
        #     mrt.append(temp)
        # print(mrt)
        # plt.hist(mrt, bins=50, edgecolor='k')
        # plt.show()

        # lam = 9.72
        # alpha1 = 0.01
        # alpha2 = 0.4
        # beta = 0.86
        # v1 = 1.2
        # v2 = 1.47
        # fogTimeToCloudTime = 0.6
        # fogTimeLimit = 0.11
        # time_end = 10000
        arrival = getArrivalTime(lam,time_end)
        requests_number = len(arrival)
        service = getServiceTime(alpha1,alpha2,beta,requests_number)
        network = getNetworkLatency(v1,v2,requests_number)
        for i in range(len(service)):
            if service[i] <= fogTimeLimit:
                network[i] = 0.0
        # print(arrival)
        # print(service)
        # print(network)
        #print(fogTimeLimit,fogTimeToCloudTime,time_end)
        #para_list = para.split('\n')
        result = Simulation(arrival, service, fogTimeLimit, network, fogTimeToCloudTime)
        #print(result[0])

        # remove first k jobs in order to plot the transient removal figure
        # for i in range(0,2000):
        #     result.pop(i)
        # #print(result)
        # total = 0
        # list = []
        # for i in range(len(result)):
        #     total += result[i]
        # a = len(result)
        # mean_response_time = total/a
        # mean_response_time = round(mean_response_time,4)
        # list.append(mean_response_time)
        # print(list)

        # print k josbs mean response time in order to see transient removal
        # x_axies = []
        # y_axies = []
        # for i in range(1, len(result) + 1):
        #     x_axies.append(i)
        #     y_axies.append(statistics.mean(result[:i]))
        # plt.plot(x_axies, y_axies)
        # plt.ylabel('Mean response time of first k jobs')
        # #plt.ylabel('Mean response time of first k jobs(after transient remove)')
        # plt.xlabel('k')
        # plt.show()

        # write results into txt file
        with open('mrt_{}.txt'.format(text_index), 'w') as f:
            f.write("%.4f" % result[0])

        with open('fog_dep_{}.txt'.format(text_index), 'w') as f:
            for i in range(len(result[1])):
                if result[1][i][1] <= time_end:
                    f.write(format(result[1][i][0], '0.4f'))
                    f.write('\t')
                    f.write(format(result[1][i][1], '0.4f'))
                    f.write('\n')

        with open('net_dep_{}.txt'.format(text_index), 'w') as f:

            for i in range(len(result[2])):
                if result[2][i][1] <= time_end:
                    f.write(format(result[2][i][0], '0.4f'))
                    f.write('\t')
                    f.write(format(result[2][i][1], '0.4f'))
                    f.write('\n')

        with open('cloud_dep_{}.txt'.format(text_index), 'w') as f:
            for i in range(len(result[3])):
                if result[3][i][1] <= time_end:
                    f.write(format(result[3][i][0], '0.4f'))
                    f.write('\t')
                    f.write(format(result[3][i][1], '0.4f'))
                    f.write('\n')
