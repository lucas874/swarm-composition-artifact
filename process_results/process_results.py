from process_execution_time_results import cbor_to_csv
from process_subscription_size_results import subscription_results
from generate_plots import two_plots
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description="Turn experiment results in to csvs")
    parser.add_argument('-a', '--accuracy', type=str, help='Folder containing subscription size results')
    parser.add_argument('-p', '--performance', type=str, help='Folder containing execution time results')
    parser.add_argument('--short', action='store_true', help='Short run option (running with full benchmark suite is default)')
    args = parser.parse_args()

    if not args.accuracy or not args.performance:
        parser.print_help()
        sys.exit(1)

    result_directory = f"results_short_run" if args.short else f"results"
    execution_time_csv_filename = "general_pattern_microseconds_performance_results_edges.csv"
    cbor_to_csv(args.performance, result_directory, execution_time_csv_filename)

    sub_size_csv_filename = "subscription_sizes_efrac.csv"
    subscription_results(args.accuracy, result_directory, sub_size_csv_filename)

    output_pdf_filename = f"{result_directory}/out.pdf"
    two_plots(f"{result_directory}/{execution_time_csv_filename}", f"{result_directory}/{sub_size_csv_filename}", output_pdf_filename)

main()