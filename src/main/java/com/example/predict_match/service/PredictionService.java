package com.example.predict_match.service;

import com.example.predict_match.model.dto.PredictedMatch;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.repository.PredictionRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PredictionService {
    private final PredictionRepository predictionRepository;

    public PredictionService(PredictionRepository predictionRepository) {
        this.predictionRepository = predictionRepository;
    }

    public PredictedMatch createOrUpdatePrediction(User user, int matchId, int predictedWinnerId) throws Exception {
        PredictedMatch existingPrediction = predictionRepository.findByUserIdAndMatchId(user.userId(), matchId);

        if (existingPrediction != null) {
            PredictedMatch updatedPrediction = new PredictedMatch(
                    existingPrediction.id(),
                    existingPrediction.userId(),
                    existingPrediction.matchId(),
                    predictedWinnerId,
                    existingPrediction.isCorrect(),
                    existingPrediction.createdAt()
            );
            predictionRepository.update(updatedPrediction);
            return updatedPrediction;
        } else {
            PredictedMatch newPrediction = new PredictedMatch(
                    null,
                    user.userId(),
                    matchId,
                    predictedWinnerId,
                    null,
                    null
            );
            return predictionRepository.save(newPrediction);
        }
    }

    public List<PredictedMatch> getUserPredictions(Long userId) throws Exception {
        return predictionRepository.findByUserId(userId);
    }

    public PredictedMatch getUserPredictionForMatch(Long userId, int matchId) throws Exception {
        return predictionRepository.findByUserIdAndMatchId(userId, matchId);
    }
}
