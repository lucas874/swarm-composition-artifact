from process_execution_time_results import cbor_to_csv
from process_subscription_size_results import subscription_results
from generate_plots import two_plots
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description="Turn experiment results in to csvs")
    parser.add_argument('-a', '--accuracy', type=str, help='Directory containing subscription size results')
    parser.add_argument('-p', '--performance', type=str, help='Directory containing execution time results')
    parser.add_argument('-b', '--benchmarks', type=str, help='Directory containing benchmarks')
    parser.add_argument('-o', '--output_directory', type=str, help='Directory to store plots and csvs')
    args = parser.parse_args()

    if not args.accuracy or not args.performance or not args.benchmarks:
        parser.print_help()
        sys.exit(1)

    execution_time_csv_filename = "performance_results.csv"
    cbor_to_csv(args.performance, args.output_directory, execution_time_csv_filename, args.benchmarks)

    sub_size_csv_filename = "accuracy_results.csv"
    subscription_results(args.accuracy, args.output_directory, sub_size_csv_filename)

    output_pdf_filename = f"{args.output_directory}/figures.pdf"
    two_plots(f"{args.output_directory}/{execution_time_csv_filename}", f"{args.output_directory}/{sub_size_csv_filename}", output_pdf_filename)

if __name__ == "__main__":
    main()