import * as React from "react";
import { StyleSheet, css } from "aphrodite";
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  LinearScale,
} from "chart.js";
// @ts-ignore
import { Socket } from "phoenix";

import { FormBox } from "./../FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    minHeight: 500,
    maxHeight: 500,
    marginRight: 30,
    display: "flex",
    flexDirection: "column",
  },
  header: {
    flexGrow: 0,
    flexShrink: 0,
    flexBasis: "auto",
    display: "flex",
    justifyContent: "space-between",
  },
  body: {
    flexGrow: 1,
    maxHeight: "100%",
    overflow: "hidden",
  },
  canvas: {
    width: 278,
    height: 457,
  },
});

interface Props {
  channel: any;
}
interface State {
  chartId: string;
  chart?: Chart;
  socket?: any;
  channel?: any;
}
export class TwitchEmoteWatcher extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    const { socket, channel } = this.subscribe();
    this.state = {
      chartId: "chart",
      socket,
      channel,
    };
  }

  render() {
    return (
      <FormBox styles={style.container}>
        <div className={css(style.header)}>
          <h3 className="text-lg mb-3">Emotes (60 second window)</h3>
        </div>
        <div className={css(style.body)}>{this.renderBody()}</div>
      </FormBox>
    );
  }

  renderBody() {
    const { chartId } = this.state;
    return (
      <canvas
        className={css(style.canvas)}
        id={chartId}
        width="278"
        height="457"
      />
    );
  }

  componentDidMount() {
    const { chartId } = this.state;
    const canvas = document.getElementById(chartId) as HTMLCanvasElement;
    Chart.register(BarController, BarElement, CategoryScale, LinearScale);
    const context = canvas.getContext("2d");
    if (!context) {
      throw "couldn't find context"
    }

    const chart = new Chart(context, {
      type: "bar",
      data: {
        datasets: [
          {
            label: "",
            data: [],
            backgroundColor: "rgba(255, 99, 132, 0.2)",
            borderWidth: 1,
          },
        ],
      },
      options: {
        indexAxis: "y",
      },
    });
    this.setState({ chart });
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  subscribe() {
    const socket = new Socket("/twitchsocket", {});
    socket.connect();

    const name = this.props.channel.name.substr(1);
    const channelName = `twitch_emote:${name}`;
    const channel = socket.channel(channelName, {});

    channel.on("one_minute_window", (message) =>
      this.oneMinuteWindowUpdate(message),
    );

    channel
      .join()
      .receive("ok", () => console.log(`Joined ${channelName}!`))
      .receive("error", (resp) => console.log("Error joining :(", resp));

    return { socket, channel };
  }

  unsubscribe() {
    const { channel } = this.state;
    if (channel) {
      channel.leave();
    }
  }

  oneMinuteWindowUpdate(emotes) {
    const entries = Object.keys(emotes).map((key) => [key, emotes[key]]);
    const sortedEntries = entries
      .sort((a, b) => {
        const [aEmote, aCount] = a;
        const [bEmote, bCount] = b;

        if (aCount < bCount) {
          return 1;
        }

        if (aCount > bCount) {
          return -1;
        }

        return 0;
      })
      .slice(0, 15);

    const sortedKeys = sortedEntries.map((entry) => entry[0]);
    const sortedValues = sortedEntries.map((entry) => entry[1]);

    const { chart } = this.state;

    if (chart) {
      chart.data.labels = sortedKeys;
      chart.data.datasets[0].data = sortedValues;
      chart.update();
    }
  }
}
