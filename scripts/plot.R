library(ggplot2)
library(reshape)
library(grid)


setwd("/Users/akee/School/UCLA/01\ thesis/uclathesis")

full_width <- 5.5


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
#                      4 PRBS input sequences                         #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

data <- read.csv("data/prbs_inputs.csv", header = FALSE)

pitch <- data$V1
roll  <- data$V2
yaw   <- data$V3
k     <- seq_along(pitch)

# recombine the individual measurements into a dataframe
df <- data.frame(k,pitch,roll,yaw)

# melt that shit
df.melted <- melt(df, id = "k")

# plot
p <-
	ggplot(df.melted) +
	geom_step(aes(x = k, y = value)) +
	facet_grid(variable ~ .) +
	ylab("r_k") +
	scale_y_continuous(breaks = seq(-1,1,1)) +	# min, max, interval
	scale_x_continuous(breaks = seq(0,100,25))+	# min, max, interval

	theme(
		panel.margin = unit(0.2, "in"),
		panel.grid.minor = element_blank(),
		strip.text.y = element_text(angle = 0),
		axis.title.y = element_text(angle = 0, hjust = -0.25),
		axis.title.x = element_text(vjust = -0.25)
	)

pdf("fig/prbs_input.pdf", width = full_width, height=3.5)
print(p)
dev.off()



