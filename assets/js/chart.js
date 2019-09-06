import Chart from 'chart.js';

Chart.defaults.global.defaultFontFamily = 'Montserrat';
Chart.defaults.global.defaultFontColor = '#fff';

const main = () => {
    const ctx = $("#chart");

    if (!ctx.length) return;

    const data = ctx.data("chart");

    console.log([data[1], data[2], data[3], data[4], data[5]])

    new Chart(ctx
        , {
            type: 'horizontalBar',
            data: {
                labels: ["5 Star", "4 Star", "3 Star", "2 Star", "1 Star"],
                datasets: [
                    {
                        label: "# of Reviews",
                        backgroundColor: ["#e3342f", "#f6993f", "#f66d9b", "#3490dc", "#38c172"].reverse(),
                        data: [data[5], data[4], data[3], data[2], data[1]],
                        fontFamily: "Montserrat",
                    }
                ]
            },
            options: {
                scales: {
                    xAxes: [{
                        ticks: {
                            fixedStepSize: 1
                        },
                        gridLines: {
                            color: "rgba(255,255,255,.1)"
                        }
                    }],
                    yAxes: [{
                        gridLines: {
                            color: "rgba(255,255,255,.1)"
                        }
                    }],
                },
                legend: {
                    display: false,
                    labels: {
                        defaultFontFamily: "Montserrat",
                    }
                },
                title: {
                    display: false,
                    text: '# of Reviews by Rating',
                }
            }
        })
};


up.compiler("#chart", function () {
    main()
});