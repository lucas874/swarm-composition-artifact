import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

def two_plots(execution_time_csv, subscription_size_csv, out_filename):
    execution_times = pd.read_csv(execution_time_csv)
    execution_times.rename(columns={"exact_microseconds": "Exact", "overapproximated_microseconds": "Algorithm 1"}, inplace=True)
    execution_times = execution_times.melt(id_vars=["number_of_edges", "state_space_size"])
    subscription_sizes = pd.read_csv(subscription_size_csv)
    subscription_sizes.rename(columns={"exact_efrac": "Exact", "overapproximated_efrac": "Algorithm 1"}, inplace=True)
    subscription_sizes = subscription_sizes.melt(id_vars=["number_of_edges", "state_space_size"])
    sns.set_theme()
    sns.set_style("whitegrid")
    fig, ax =plt.subplots(1,2, figsize=(15, 5), gridspec_kw={'width_ratios': [3, 1]})
    plot1 = sns.lineplot(data=execution_times, x="number_of_edges", y="value", hue="variable", palette=['r', 'b'], ax=ax[0])
    plot1.set(xlabel="Number of transitions in composition (logarithmic scale)", ylabel="time (microseconds, logarithmic scale)", xscale="log", yscale="log")
    plot2 = sns.boxplot(x="variable", y="value", data=subscription_sizes, hue="variable", palette=['r', 'b'], showmeans=True, ax=ax[1])
    plot2.set(xlabel="", ylabel="Efrac")
    plt.savefig(out_filename, format="pdf", dpi=600, bbox_inches="tight")