async function callGetCatalogAPI() {
            const dataset_name = document.getElementById('workload-dataset').value.trim();
            if (!dataset_name) {
                document.getElementById('result').textContent = 'Please Select a Workload!';
                return;
            }

            const payload = { dataset_name: dataset_name};

            try {
                const response = await fetch('http://127.0.0.1:9000/get_catalog', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                //const data = await response.text();//await response.json();

                if (response.ok) {
                    // document.getElementById('result').innerHTML = data
                    const fig = await response.json();

                    Plotly.newPlot(
                        'result',
                        fig.data,
                        fig.layout,
                        { responsive: true }
                    );

                    //-----------------
                } else {
                    document.getElementById('result').textContent = 'Error: ' + JSON.stringify(data, null, 2);
                }
            } catch (error) {
                document.getElementById('result').textContent = 'Network error: ' + error.message;
            }
        }